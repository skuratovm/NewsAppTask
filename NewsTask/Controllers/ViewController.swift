//
//  ViewController.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 3.02.22.
//

import UIKit

class ViewController: UIViewController {
    
    var fetchingMore = false
    let date = Date()
    let formatter = ISO8601DateFormatter()
    let interval = DateInterval()
    var currentDate = String()
    var newDate = String()
    
    func configuredURL(fromDate: String, toDate: String) -> URL?  {
        
        var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
        let fromDate = URLQueryItem(name: "from", value: fromDate)
        let toDate = URLQueryItem(name: "to", value: toDate)
        let language = URLQueryItem(name: "language", value: "en")
        let domains = URLQueryItem(name: "domains", value: "bbc.co.uk, techcrunch.com, engadget.com")
        
        let secretAPIKey = URLQueryItem(name: "apiKey", value: "4422f96630b14214a9f929141e0b2393")
        
        everythingUrl?.queryItems?.append(language)
        everythingUrl?.queryItems?.append(domains)
        everythingUrl?.queryItems?.append(fromDate)
        everythingUrl?.queryItems?.append(toDate)
        everythingUrl?.queryItems?.append(secretAPIKey)
        return everythingUrl?.url
    }
    
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
        //print(APICaller.shared.configuredURL())
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsInfo")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        createSearchBar()
        fetchTopStories()
        
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
        var dateValue = Date()
        
        var BDateValue = dateValue.addingTimeInterval(TimeInterval(-1*24*60*60))
        var toDateValue = formatter.string(from: dateValue)
        var fromDateValue = formatter.string(from: BDateValue)
        
        APICaller.shared.getCurrentDayNews(pagination: true, url:configuredURL(fromDate: fromDateValue, toDate: toDateValue)) { [weak self] result in
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
    private func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
        
    }
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
            DataBase.shared.saveArticle(result: self.searchedArticles[indexPath.row],row: indexPath.row)
            self.tableView.reloadData()
        }
        
        return action
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchedArticles.count - 1{
            daysCounter += 1
            if daysCounter < 8 {
                
                let dateValue = Date()
                
                let ADateValue = dateValue.addingTimeInterval(TimeInterval(-daysCounter*24*60*60))
                let BDateValue = dateValue.addingTimeInterval(TimeInterval(-(daysCounter + 1)*24*60*60))
                let toDateValue = formatter.string(from: ADateValue)
                let fromDateValue = formatter.string(from: BDateValue)
                
                
                APICaller.shared.getPaginatedNews(pagination: true, url:configuredURL(fromDate: fromDateValue, toDate: toDateValue)) { [weak self] result in
                    DispatchQueue.main.async {
                        self?.tableView.tableFooterView = nil
                    }
                    
                    
                    switch result{
                    case .success(let articles):
                        print(articles)
                        self?.articles = articles
                        self?.viewModels = articles.compactMap({
                            NewsTableViewCellViewModel(
                                title: $0.title,
                                subtitle: $0.description ?? "No Description",
                                imageURL: URL(string: $0.urlToImage ?? "")
                            )
                        })
                        var sss = [NewsTableViewCellViewModel]()
                        sss = articles.compactMap({
                            NewsTableViewCellViewModel(
                                title: $0.title,
                                subtitle: $0.description ?? "No Description",
                                imageURL: URL(string: $0.urlToImage ?? "")
                            )
                        })
                        self?.searchedArticles.append(contentsOf: sss)
                        // Once ViewModels are ready, table view should refresh
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                return
            }
        }
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

