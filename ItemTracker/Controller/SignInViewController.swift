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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInTapped(_ sender: Any) {
        presentViewController(storyboardId: Constants.StoryboardId.MainTabsController)
    }
}
