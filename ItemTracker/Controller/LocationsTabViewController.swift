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
    fileprivate var _refHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        FirebaseClient.getLocations { (locations, error) in
            print("FirebaseClient.getLocations closure")
        }
    }
    
    func configureDatabase() {
        let locationPath = FirebaseClient.DatabaseCollection.location(uid: Auth.auth().currentUser?.uid ?? "").path
      ref = Database.database().reference()
        _refHandle = self.ref.child(locationPath).observe(.childAdded, with: { [weak self] (snapshot) -> Void in
        guard let strongSelf = self else { return }
        strongSelf.locations.append(snapshot)
        print(strongSelf.locations)
      })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
}
