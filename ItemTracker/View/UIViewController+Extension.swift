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
    
    func presentViewController(storyboardId: String) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
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
}
