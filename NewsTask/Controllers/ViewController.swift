//
//  ViewController.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 3.02.22.
//

import UIKit

class ViewController: UIViewController {

    var daysCounter = 1
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private var searchedArticles = [NewsTableViewCellViewModel]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    var searching = false
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(APICaller.shared.configuredURL())
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsInfo")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
        createSearchBar()
        fetchTopStories()
       
        
        // Do any additional setup after loading the view.
    }
    @objc func refresh(_ sender: AnyObject){
        fetchTopStories()
        daysCounter = 1
    }
    private func createSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    private func fetchTopStories () {
        APICaller.shared.getTopStories { [weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                self?.searchedArticles = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                // Once ViewModels are ready, table view should refresh
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsInfo", for: indexPath) as! NewsTableViewCell
        cell.configure(with: searchedArticles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavorite = self.addToFavorites(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [addToFavorite])
        return swipe
    }
    private func addToFavorites(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Add to favorites") { [weak self]_, _, _ in
            guard let self = self else {return}
            DataBase.shared.saveSchedule(result: self.searchedArticles[indexPath.row],row: indexPath.row)
            self.tableView.reloadData()
        }
        
        return action
    }
    
}

extension ViewController: UISearchBarDelegate,UISearchControllerDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedArticles = []
        if searchText == ""{
            searchedArticles = viewModels
        } else {
            for news in viewModels{
                        if news.title.lowercased().contains(searchText.lowercased()){
                            searchedArticles.append(news)
                        }
                    }
        }
        self.tableView.reloadData()
        }
    
    
}

