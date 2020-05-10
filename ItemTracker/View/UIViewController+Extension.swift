//
//  UIViewController+Extension.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    
    func getThumbnail(selectionType: SelectionType) -> UIImage? {
        switch selectionType {
            case .location:
                return UIImage(named: Constants.Image.locationPlaceholder)
            case .storage:
                return UIImage(named: Constants.Image.storagePlaceholder)
            case .item:
                return UIImage(named: Constants.Image.itemPlaceholder)
        }
    }
    
    func presentViewController(storyboardId: String) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = delegate
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        presentViewController(storyboardId: Constants.StoryboardId.LoginController)
    }
    
    // MARK: Handle keyboard will show
    func subscribeToKeyboardWillShowNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardWillShowNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = 0
        view.frame.origin.y -= 150
    }
    
    // MARK: Handle Keyboard will hide
    func subscribeToKeyboardWillHideNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardWillHideNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}
