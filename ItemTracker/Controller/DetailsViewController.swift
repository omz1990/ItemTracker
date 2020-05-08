//
//  DetailsViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 9/5/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subNameView: UIView!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var location: Location!
    var storage: Storage!
    var item: Item!
    var selectionType: SelectionType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionType = .location
        subNameView?.isHidden = selectionType != SelectionType.location
        
        initDisplay()
    }
    
    private func initDisplay() {
        if selectionType == SelectionType.location {
            titleLabel?.text = "Location Details"
            nameLabel?.text = location.name
            subNameLabel?.text = location.subName ?? "-"
            descriptionLabel?.text = location.description ?? "No description provided..."
        } else if selectionType == SelectionType.storage {
            titleLabel?.text = "Storage Details"
            nameLabel?.text = storage.name
            descriptionLabel?.text = storage.description ?? "No description provided..."
        } else if selectionType == SelectionType.item {
            titleLabel?.text = "Item Details"
            nameLabel?.text = item.name
            descriptionLabel?.text = item.description ?? "No description provided..."
        }
    }

}
