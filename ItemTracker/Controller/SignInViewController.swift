//
//  SignInViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 16/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var googleSignInView: RoundedView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailBottomBorder: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordBottomBorder: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var googleSignInGestureRecognizer: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoadingState(isLoading: true)
        if Auth.auth().currentUser != nil {
            self.presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
        } else {
            initGoogleSignInListener()
            setLoadingState(isLoading: false)
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    private func initGoogleSignInListener() {
        googleSignInGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(self.googleSignInTapped))
        googleSignInView.addGestureRecognizer(googleSignInGestureRecognizer)
    }

    @objc func googleSignInTapped(sender : UITapGestureRecognizer) {
        print("Google Sign in tapped")
        setLoadingState(isLoading: true)
        GIDSignIn.sharedInstance().signIn()
        googleSignInView.removeGestureRecognizer(googleSignInGestureRecognizer)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if validateTextFields() {
            signInUser()
        } else {
            showAlert(title: Constants.ErrorMessage.incompleteFieldsTile, message: Constants.ErrorMessage.incompleteFieldsBody)
        }
    }
    
    private func signInUser() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        setLoadingState(isLoading: true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                if error == nil {
                    strongSelf.presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
                } else {
                    strongSelf.setLoadingState(isLoading: true)
                    strongSelf.showAlert(title: "Error", message: error?.localizedDescription ?? "Could not login. Please try again!")
                }
            }
        }
    }
    
    private func validateTextFields() -> Bool {
        let errorColor: UIColor = .red
        let validColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        var valid = true
        
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
        
        return valid
    }
    
    private func setLoadingState(isLoading: Bool) {
        if isLoading {
            activityIndicator?.startAnimating()
            if let gr = googleSignInGestureRecognizer {
                googleSignInView?.removeGestureRecognizer(gr)
            }
        } else {
            activityIndicator?.stopAnimating()
            if let gr = googleSignInGestureRecognizer {
                googleSignInView?.addGestureRecognizer(gr)
            }
        }
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        signInButton.isEnabled = !isLoading
        signUpButton.isEnabled = !isLoading
    }
}

extension SignInViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            self.showAlert(title: "Error", message: "Could not login. Please try again!")
            return
        }
        setLoadingState(isLoading: true)
        guard user.profile.email != nil else { return }

        guard let authentication = user.authentication else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
        }
    }
}
