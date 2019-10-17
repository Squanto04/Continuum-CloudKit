//
//  PostListTableViewController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var resultsArray: [SearchableRecord] = []
    var isSearching: Bool = false
    var dataSource: [SearchableRecord] {
        return isSearching ? resultsArray : PostController.shared.posts
    }
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 465
//        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        performFullSync(completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        resultsArray = PostController.shared.posts
    }
    
    // MARK: - Helper Functions
    func performFullSync(completion:((Bool) -> Void)?) {
        PostController.shared.fetchPosts { (posts) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completion?(posts != nil)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        let post = dataSource[indexPath.row] as? Post
        cell.post = post
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC" {
            guard let index = tableView.indexPathForSelectedRow else { return }
            guard let destinationVC = segue.destination as? PostDetailTableViewController else { return }
            let objectToSend = dataSource[index.row] as? Post
            destinationVC.post = objectToSend
        }
    }
    
}//EOC

    // MARK: - Search Bar Delegate
extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter { $0.matches(searchTerm: searchText) }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
}
