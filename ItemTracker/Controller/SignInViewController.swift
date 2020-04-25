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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var googleSignInGestureRecognizer: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
        } else {
            initGoogleSignInListener()
        }
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
        GIDSignIn.sharedInstance().signIn()
        googleSignInView.removeGestureRecognizer(googleSignInGestureRecognizer)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
    }
}

extension SignInViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error)
            return
        }

        guard let email = user.profile.email else { return }

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
