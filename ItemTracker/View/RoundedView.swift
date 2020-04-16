//
//  RoundedView.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 16/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

@IBDesignable public class RoundedView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
