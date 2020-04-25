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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var ref: DatabaseReference!
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellSize()
        fetchLocations()
    }
    
    private func fetchLocations() {
        activityIndicator.startAnimating()
        
        FirebaseClient.getLocations { (locations, error) in
            DispatchQueue.main.async {
                guard let locations = locations else {
                    print("Could not find any locations")
                    return
                }
                self.locations = locations
                self.collectionView?.reloadData()
                self.activityIndicator?.stopAnimating()
                
                print("FirebaseClient.getLocations closure")
                print("Total Locations: \(locations.count)")
                locations.forEach({ (location) in
                    print("Total storages for location: \(location.name) : \(location.storages?.count ?? 0)")
                    location.storages?.forEach({ (storage) in
                        print("Total items for storage: \(storage.name) : \(storage.items?.count ?? 0)")
                    })
                })
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
}

// MARK: Extension to handle Collection View
extension LocationsTabViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.View.LocationCell, for: indexPath) as! LocationCollectionViewCell
        let location = locations[indexPath.row]
        
        let storagesCount = location.storages?.count ?? 0
        cell.storageUnitsTextView.text = "Storage Units: \(storagesCount)"
        
        let itemsCount = location.getTotalItemsCount()
        cell.itemsTextView.text = "Items: \(itemsCount)"
        
        let locationSubName = location.subName?.isEmpty == true ? "" : "/\(location.subName ?? "")"
        let name = "\(location.name)\(locationSubName)"
        cell.locationNameTextView.text = name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    // MARK: Set collection view cell size helpers
    private func setCellSize() {
        let space: CGFloat = 4.0
        let dimension = calculteCellSize(space)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    private func calculteCellSize(_ space: CGFloat) -> CGFloat {
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        // Select a baseWidth to calculate the cell size
        // If the screen is portrait, we should do screenWidth/2
        // If the screen is landscapes we should do screenWidth/2
        let currentScreenOrientation = UIApplication.shared.statusBarOrientation
        let baseWidth = currentScreenOrientation.isPortrait ? screenWidth : screenHeight
        
        return (baseWidth - (2 * space)) / 2.0
    }
}
