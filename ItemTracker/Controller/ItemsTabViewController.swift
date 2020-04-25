//
//  ItemsTabViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class ItemsTabViewController: UIViewController {
    
    var allLocations: [Location] = []
    var allItems: [Item] = []
    var displayedItems: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
}

extension ItemsTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = displayedItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.View.ItemRow, for: indexPath) as! ItemTableViewCell
        cell.titleTextView.text = item.name
        cell.locationTextView.text = item.locationId
        cell.storageTextView.text = item.storageId
        return cell
    }
    
    
}
