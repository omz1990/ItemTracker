//
//  LocationsTabViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation
import UIKit

class LocationsTabViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allLocations: [Location] = []
    var displayedLocations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellSize()
        fetchLocations()
    }
    
    private func fetchLocations() {
        activityIndicator.startAnimating()
        
        FirebaseClient.getLocations { (locations, error) in
            guard let locations = locations else {
                print("Could not find any locations")
                return
            }
            
            DispatchQueue.main.async {
                self.allLocations = locations
                self.displayedLocations = locations
                self.collectionView?.reloadData()
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.AddNewViewController) as! AddNewViewController
        vc.selectionType = .location
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

// MARK: Extension to handle Collection View
extension LocationsTabViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.View.LocationCell, for: indexPath) as! LocationCollectionViewCell
        let location = displayedLocations[indexPath.row]
        
        let storagesCount = location.storages?.count ?? 0
        cell.storageUnitsTextView.text = "Storage Units: \(storagesCount)"
        cell.itemsTextView.text = "Items: \(location.getTotalItemsCount())"
        cell.locationNameTextView.text = location.getDisplayName()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedLocations.count
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

// MARK: Extension to handle Search bar
extension LocationsTabViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayedLocations = allLocations
        } else {
            displayedLocations = allLocations.filter({ (location) -> Bool in
                return location.getDisplayName().containsIgnoringCase(searchText)
            })
        }
        collectionView?.reloadData()
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
        displayedLocations = allLocations
        collectionView?.reloadData()
    }
}
