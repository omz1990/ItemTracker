//
//  DetailsViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 9/5/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameView: UIView!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subListContainer: UIView!
    @IBOutlet weak var subListTitle: UILabel!

    @IBOutlet weak var viewAllISubItemsButton: UIButton!
    
    var location: Location!
    var storage: Storage!
    var item: Item!
    var operationPath: OperationPath!
    var selectionType: SelectionType!
    
    let locationIcon = UIImage(named: Constants.Image.locationPlaceholder)
    let storageIcon = UIImage(named: Constants.Image.storagePlaceholder)
    let itemIcon = UIImage(named: Constants.Image.itemPlaceholder)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDisplay()
    }
    
    private func initDisplay() {
        
        thumbnailImageView?.image = getThumbnail(selectionType: selectionType)
        titleLabel?.text = getScreenTitle()
        nameLabel?.text = getName(location, storage, item)
        descriptionLabel?.text = getDescription(location, storage, item)
        subListTitle?.text = getSubListTitle(location, storage)
        
        subNameLabel?.text = getSubName()
        subNameView?.isHidden = selectionType != SelectionType.location
        
        subListContainer?.isHidden = selectionType == SelectionType.item
        viewAllISubItemsButton?.setTitle(getButtonText(), for: .normal)
    }
    
    @IBAction func viewAllSubItemsTapped(_ sender: Any) {
        if selectionType == SelectionType.location {
            // Open storages
            let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.SelectViewController) as! SelectViewController
            vc.selectionType = .storage
            vc.operationPath = operationPath
            vc.selectedLocation = location
            self.navigationController!.pushViewController(vc, animated: true)
            
        } else if selectionType == SelectionType.storage {
            // Open items list
            let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.SelectViewController) as! SelectViewController
            vc.selectionType = .item
            vc.operationPath = operationPath
            vc.selectedStorage = storage
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    private func getName(_ location: Location?, _ storage: Storage?, _ item: Item?) -> String {
        let noDescriptionString = "Unknown"
        switch selectionType {
            case .location:
                return location?.name ?? noDescriptionString
            case .storage:
                return storage?.name ?? noDescriptionString
            case .item:
                return item?.name ?? noDescriptionString
            default:
                return noDescriptionString
        }
    }
    
    private func getDescription(_ location: Location?, _ storage: Storage?, _ item: Item?) -> String {
        let noDescriptionString = "No description provided..."
        switch selectionType {
            case .location:
                return location?.description?.isEmpty == true ? noDescriptionString : location?.description ?? noDescriptionString
            case .storage:
                return storage?.description?.isEmpty == true ? noDescriptionString : storage?.description ?? noDescriptionString
            case .item:
                return item?.description?.isEmpty == true ? noDescriptionString : item?.description ?? noDescriptionString
            default:
                return noDescriptionString
        }
    }
    
    private func getSubName() -> String {
        return location?.subName ?? "-"
    }
    
    private func getScreenTitle() -> String {
        switch selectionType {
            case .location:
                return "Location Details"
            case .storage:
                return "Storage Details"
            case .item:
                return "Item Details"
            default:
                return "Unknown"
        }
    }
    
    private func getButtonText() -> String {
        switch selectionType {
            case .location:
                return "View or Add Storages"
            case .storage:
                return "View or Add Items"
            default:
                return "-"
        }
    }
    
    private func getSubListTitle(_ location: Location?, _ storage: Storage?) -> String {
        switch selectionType {
           case .location:
               return "Storages: \(location?.storages?.count ?? 0)"
           case .storage:
               return "Items: \(storage?.items?.count ?? 0)"
           default:
               return ""
       }
    }
}
