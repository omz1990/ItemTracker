//
//  SelectViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 6/5/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectionType: SelectionType!
    
    var allLocations: [Location]!
    var displayedLocations: [Location]!
    
    var allStorages: [Storage] = []
    var displayedStorages: [Storage] = []
    
    var allItems: [Item] = []
    var displayedItems: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionType = selectionType ?? .location

        let nibName = UINib(nibName: Constants.View.OverviewTableView, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constants.View.ItemRow)
    }
    
}

// MARK: Extension to handle Table View
extension SelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectionType {
            case .location:
                return displayedLocations.count
            case .storage:
                return displayedStorages.count
            case .item:
                return displayedItems.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var location: Location? = nil
        var storage: Storage? = nil
        var item: Item? = nil
        
        if selectionType == SelectionType.location {
            location = displayedLocations[indexPath.row]
        } else if selectionType == SelectionType.storage {
            storage = displayedStorages[indexPath.row]
        } else if selectionType == SelectionType.item {
            item = displayedItems[indexPath.row]
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.View.ItemRow) as! OverviewTableViewCell
        
        let title = getHeading(location: location, storage: storage, item: item)
        let line1Body = getLineOneBody(location: location, storage: storage, item: item)
        let line2Body = getLineTwoBody(location: location, storage: storage, item: item)
        
        cell.initCell(heading: title, line1Title: getLineOneTitle(), line1Body: line1Body, line2Title: getLineTwoTitle(), line2Body: line2Body, image: nil)
        
        return cell
    }
    
    private func getHeading(location: Location?, storage: Storage?, item: Item?) -> String? {
        switch selectionType {
            case .location:
                return location?.getDisplayName() ?? ""
            case .storage:
                return storage?.name ?? ""
            case .item:
                return item?.name ?? ""
            default:
                return nil
        }
    }
    
    private func getLineOneTitle() -> String? {
        switch selectionType {
            case .location:
                return "Storages"
            case .storage, .item:
                return "Location"
            default:
                return nil
        }
    }
    
    private func getLineOneBody(location: Location?, storage: Storage?, item: Item?) -> String? {
        switch selectionType {
            case .location:
                return "\(location?.storages?.count ?? 0)"
            case .storage:
                return storage?.locationName ?? ""
            case .item:
                return item?.locationName ?? ""
            default:
                return nil
        }
    }
    
    private func getLineTwoTitle() -> String? {
        switch selectionType {
            case .location, .storage:
                return "Items"
            case .item:
                return "Storage"
            default:
                return nil
        }
    }
    
    private func getLineTwoBody(location: Location?, storage: Storage?, item: Item?) -> String? {
        switch selectionType {
            case .location:
                return "\(location?.getTotalItemsCount() ?? 0)"
            case .storage:
                return "\(storage?.items?.count ?? 0)"
            case .item:
                return item?.locationName ?? ""
            default:
                return nil
        }
    }
    
}

// MARK: Extension to handle Search bar
extension SelectViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if selectionType == SelectionType.location {
            if searchText.isEmpty {
                displayedLocations = allLocations
            } else {
                displayedLocations = allLocations.filter({ (item) -> Bool in
                    return item.name.containsIgnoringCase(searchText)
                })
            }
        } else if selectionType == SelectionType.storage {
            if searchText.isEmpty {
                displayedStorages = allStorages
            } else {
                displayedStorages = allStorages.filter({ (item) -> Bool in
                    return item.name.containsIgnoringCase(searchText)
                })
            }
        } else if selectionType == SelectionType.item {
            if searchText.isEmpty {
                displayedItems = allItems
            } else {
                displayedItems = allItems.filter({ (item) -> Bool in
                    return item.name.containsIgnoringCase(searchText)
                })
            }
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
        if selectionType == SelectionType.location {
            displayedLocations = allLocations
        } else if selectionType == SelectionType.storage {
            displayedStorages = allStorages
        } else if selectionType == SelectionType.item {
            displayedItems = allItems
        }
        
        displayedLocations = allLocations
        tableView?.reloadData()
        
        
        
//        if selectionType == SelectionType.location {
//
//        } else if selectionType == SelectionType.storage {
//
//        } else if selectionType == SelectionType.item {
//
//        }
    }
}
