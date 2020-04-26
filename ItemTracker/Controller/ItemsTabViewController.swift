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
    
    var allLocations: [Location] = []
    var allItems: [Item] = []
    var displayedItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseClient.getLocations { (locations, error) in
            guard let locations = locations else {
                print("Could not find any locations")
                return
            }
            
            DispatchQueue.main.async {
                self.allLocations = locations
                
                guard let allItemsFromLocations = self.getAllItemsFromLocations(locations: locations) else {
                    print("Could not find any items")
                    return
                }
                self.allItems = allItemsFromLocations
                self.displayedItems = allItemsFromLocations
                self.tableView?.reloadData()
                self.activityIndicator?.stopAnimating()
            }
        }
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
}

extension ItemsTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = displayedItems[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.View.ItemRow) as! ItemTableViewCell
        cell.titleTextView.text = item.name
        cell.locationTextView.text = item.locationName
        cell.storageTextView.text = item.storageName
        return cell
    }
    
}
