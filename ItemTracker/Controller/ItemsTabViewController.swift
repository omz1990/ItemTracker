//
//  ItemsTabViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class ItemsTabViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    var allLocations: [Location] = []
    var allItems: [Item] = []
    var displayedItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: Constants.View.OverviewTableView, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constants.View.ItemRow)

        FirebaseClient.getLocations { (locations, error) in
            DispatchQueue.main.async {
                self.handleLocationsResponse(locations: locations)
            }
        }
    }
    
    private func handleLocationsResponse(locations: [Location]?) {
        let errorText = "No Items found. You can add new items by tapping on the + icon on the top left of this screen!"
        activityIndicator?.stopAnimating()
        guard let locations = locations else {
            allItems = []
            displayedItems = []
            tableView?.reloadData()
            errorLabel?.text = errorText
            return
        }
        
        allLocations = locations
        
        guard let allItemsFromLocations = self.getAllItemsFromLocations(locations: locations) else {
            allItems = []
            displayedItems = []
            tableView?.reloadData()
            errorLabel?.text = errorText
            return
        }
        errorLabel?.text = ""
        allItems = allItemsFromLocations
        displayedItems = allItemsFromLocations
        tableView?.reloadData()
    }
    
    private func getAllItemsFromLocations(locations: [Location]) -> [Item]? {
        let allStorages: [Storage]? = locations.compactMap { $0.storages }.flatMap { $0 }
        var allItems: [Item]? = allStorages?.compactMap { $0.items }.flatMap { $0 }
        
        allItems = allItems?.sorted(by: { (item1, item2) -> Bool in
            return item1.name < item2.name
        })
        
        return allItems
    }

    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.SelectViewController) as! SelectViewController
        vc.selectionType = .location
        vc.operationPath = .add
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

// MARK: Extension to handle Table View
extension ItemsTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = displayedItems[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.View.ItemRow) as! OverviewTableViewCell
        cell.initCell(heading: item.name, line1Title: "Location", line1Body: item.locationName, line2Title: "Storage", line2Body: item.storageName, image: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.DetailsViewController) as! DetailsViewController
        vc.selectionType = .item
        vc.operationPath = .view
        vc.item = displayedItems[indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}

// MARK: Extension to handle Search bar
extension ItemsTabViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayedItems = allItems
        } else {
            displayedItems = allItems.filter({ (item) -> Bool in
                return item.name.containsIgnoringCase(searchText)
            })
        }
        tableView?.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        displayedItems = allItems
        tableView?.reloadData()
    }
}
