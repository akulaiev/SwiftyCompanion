//
//  SearchViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// Search user logins, with autocomplete

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var responses = SearchResponse()
    
    var selectedIndex = 0
    
    var currentSearchTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.autocapitalizationType = .none
    }
}

// UISearchBarDelegate protocol methods
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let task = currentSearchTask {
            task.cancel()
        }
            currentSearchTask = FortyTwoAPIClient.search(query: searchText) { (responses, error) in
            self.responses = responses
            self.tableView.reloadData()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        responses = []
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        SharedHelperMethods.logoutLogic(currentVC: self)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "responsesCell")!
        let response = responses[indexPath.row]
        cell.textLabel?.text = response.login
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let vc = storyboard?.instantiateViewController(withIdentifier: "userInfo") as! UserInfoViewController
        vc.userId = String(responses[selectedIndex].id)
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
