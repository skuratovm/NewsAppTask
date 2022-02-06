//
//  FavoritesViewController.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 5.02.22.
//

import UIKit

class FavoritesViewController: UIViewController {
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsInfo")
        
    }
    


}

extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBase.shared.news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsInfo", for: indexPath) as! NewsTableViewCell
        cell.configure(with: DataBase.shared.news![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFromFavorites = self.removeFromFavorites(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [removeFromFavorites])
        return swipe
    }
    private func removeFromFavorites(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Remove from favorites") { [weak self]_, _, _ in
            guard let self = self else {return}
            DataBase.shared.deleteSchedule(result: DataBase.shared.news![indexPath.row], row: indexPath.row)
            self.tableView.reloadData()
            
        }
        
        return action
    }
    
    
    
}

