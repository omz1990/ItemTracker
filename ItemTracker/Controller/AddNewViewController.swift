//
//  AddLocationViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 27/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit
import Firebase

class AddNewViewController: UIViewController {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameBottomBorder: UIView!
    @IBOutlet weak var subNameContainerView: UIView!
    @IBOutlet weak var subNameTextField: UITextField!
    @IBOutlet weak var subNameBottomBorder: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionBottomBorder: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var operationPath: OperationPath!
    var selectionType: SelectionType!
    var location: Location!
    var storage: Storage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard events
        subscribeToKeyboardWillShowNotifications()
        subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Unsubscribe keyboard events
        unsubscribeFromKeyboardWillShowNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionType = selectionType ?? .location
        initDisplay()
    }
    
    private func initDisplay() {
        subNameContainerView.isHidden = selectionType != SelectionType.location
        topImageView.image = getThumbnail(selectionType: selectionType)
        titleLabel.text = getScreenTitle()
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        // Create
        if validateTextFields() {
            activityIndicator?.startAnimating()
            
            switch selectionType {
                case .location: createLocation()
                case .storage: createStorage()
                case .item: createItem()
                default: break
            }
        } else {
            showAlert(title: Constants.ErrorMessage.incompleteFieldsTile, message: Constants.ErrorMessage.incompleteFieldsBody)
        }
    }
    
    private func createLocation() {
        FirebaseClient.createLocation(location: getLocationObject()) { (success) in
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                if success {
                    self.handleLocationCreationSuccess()
                } else {
                    self.showAlert(title: "Error", message: "Couuld not create Location. Please try again.")
                }
            }
        }
    }
    
    private func handleLocationCreationSuccess() {
        navigationController?.popViewController(animated: true)

        if operationPath == OperationPath.add {
            navigationController?.popViewController(animated: true)
            let vc = self.storyboard!.instantiateViewController(withIdentifier: Constants.StoryboardId.SelectViewController) as! SelectViewController
            vc.selectionType = .location
            vc.operationPath = operationPath
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    private func getLocationObject() -> Location {
        return Location(id: "unknown", name: nameTextField?.text ?? "", subName: subNameTextField?.text ?? "", description: descriptionTextField?.text ?? "", imageUrl: "", type: "Other", subType: "Other", tags: [], createdAt: Date(), updatedAt: Date(), storages: nil)
    }
    
    private func createStorage() {
        FirebaseClient.createStorage(storage: getStorageObject()) { (success) in
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: "Error", message: "Couuld not create Storage. Please try again.")
                }
            }
        }
    }
    
    private func getStorageObject() -> Storage {
        return Storage(id: "unknown", locationId: location?.id ?? "", locationName: location?.name, name: nameTextField?.text ?? "", description: descriptionTextField?.text ?? "", imageUrl: "", type: "Other", tags: [], createdAt: Date(), updatedAt: Date(), items: nil)
    }
    
    private func createItem() {
        FirebaseClient.createItem(item: getItemObject() ) { (success) in
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: "Error", message: "Couuld not create Item. Please try again.")
                }
            }
        }
    }
    
    private func getItemObject() -> Item {
        return Item(id: "unknown", storageId: storage?.id ?? "", storageName: storage?.name ?? "", locationId: storage?.locationId ?? "", locationName: storage?.locationName ?? "", name: nameTextField?.text ?? "", description: descriptionTextField?.text ?? "", imageUrl: "", type: "Other", tags: [], createdAt: Date(), updatedAt: Date())
    }
    
    private func validateTextFields() -> Bool {
        let errorColor: UIColor = .red
        let validColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        var valid = true
        
        // Name field is required for all addition types
        if nameTextField.text?.isEmpty == true {
            nameBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            nameBottomBorder.backgroundColor = validColor
        }
        
        // Description field is required for all addition types
        if descriptionTextField.text?.isEmpty == true {
            descriptionBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            descriptionBottomBorder.backgroundColor = validColor
        }
        
        // Sub name is only required for Location addition type
        if (selectionType == SelectionType.location && subNameTextField.text?.isEmpty == true) {
            subNameBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            subNameBottomBorder.backgroundColor = validColor
        }
        
        return valid
    }
    
    private func getScreenTitle() -> String {
        switch selectionType {
            case .location:
                return "New Location"
            case .storage:
                return "New Storage"
            case .item:
                return "New Item"
            default:
                return "Unknown"
        }
    }
}
