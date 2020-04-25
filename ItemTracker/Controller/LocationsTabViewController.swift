//
//  LocationsTabViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit
import Firebase

class LocationsTabViewController: UIViewController {

    var ref: DatabaseReference!
    var locations: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
    }
    
    private func fetchLocations() {
        FirebaseClient.getLocations { (locations, error) in
            print("FirebaseClient.getLocations closure")
            print("Total Locations: \(locations?.count ?? 0)")
            locations?.forEach({ (location) in
                print("Total storages for location: \(location.name) : \(location.storages?.count ?? 0)")
                location.storages?.forEach({ (storage) in
                    print("Total items for storage: \(storage.name) : \(storage.items?.count ?? 0)")
                })
            })
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
}
