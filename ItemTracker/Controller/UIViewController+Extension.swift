//
//  UIViewController+Extension.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentViewController(storyboardId: String) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: storyboardId)
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
}
