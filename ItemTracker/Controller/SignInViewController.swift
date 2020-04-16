//
//  SignInViewController.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 16/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

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
        initGoogleSignInListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func initGoogleSignInListener() {
        googleSignInGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(self.googleSignInTapped))
        googleSignInView.addGestureRecognizer(googleSignInGestureRecognizer)
    }

    @objc func googleSignInTapped(sender : UITapGestureRecognizer) {
        print("Google Sign in tapped")
        googleSignInView.removeGestureRecognizer(googleSignInGestureRecognizer)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
    }
}
