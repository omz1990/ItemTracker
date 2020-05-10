//
//  SignUpViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 16/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameBottomBorder: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailBottomBorder: UIView!
    @IBOutlet weak var passwordBottomBorder: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordBottomBorder: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard events
        subscribeToKeyboardWillShowNotifications()
        subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unsubscribe keyboard events
        unsubscribeFromKeyboardWillShowNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }

    @IBAction func createAccountTapped(_ sender: Any) {
        if validateTextFields() {
            if passwordTextField.text == confirmPasswordTextField.text {
                signUpUser()
            } else {
                showAlert(title: "Error", message: "Passwords do not match!")
            }
        } else {
            showAlert(title: Constants.ErrorMessage.incompleteFieldsTile, message: Constants.ErrorMessage.incompleteFieldsBody)
        }
    }
    
    private func validateTextFields() -> Bool {
        let errorColor: UIColor = .red
        let validColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        var valid = true
        
        // Name field is required
        if nameTextField.text?.isEmpty == true {
            nameBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            nameBottomBorder.backgroundColor = validColor
        }
        
        // Email field is required
        if emailTextField.text?.isEmpty == true {
            emailBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            emailBottomBorder.backgroundColor = validColor
        }
        
        // Password field is required
        if passwordTextField.text?.isEmpty == true {
            passwordBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            passwordBottomBorder.backgroundColor = validColor
        }
        
        // Confirm Password field is required
        if confirmPasswordTextField.text?.isEmpty == true {
            confirmPasswordBottomBorder.backgroundColor = errorColor
            valid = false
        } else {
            confirmPasswordBottomBorder.backgroundColor = validColor
        }
        
        return valid
    }
    
    private func signUpUser() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        setLoadingState(isLoading: true)
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            DispatchQueue.main.async {
                guard let user = authResult?.user, error == nil else {
                    self.setLoadingState(isLoading: false)
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Could not sign up. Please try again!")
                  return
                }
                self.updateUsersDisplayName()
            }
        }
    }
    
    private func updateUsersDisplayName() {
        let name = nameTextField.text ?? ""
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            DispatchQueue.main.async {
                self.setLoadingState(isLoading: false)
                if error == nil {
                    self.presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
                } else {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Could not sign up. Please try again!")
                }
            }
        }
    }
    
    private func setLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
    }
}
