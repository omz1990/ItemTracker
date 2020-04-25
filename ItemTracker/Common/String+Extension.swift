//
//  String+Extension.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 26/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation

extension String {
    func contains(_ find: String) -> Bool{
      return self.range(of: find) != nil
    }

    func containsIgnoringCase(_ find: String) -> Bool{
      return self.range(of: find, options: .caseInsensitive) != nil
    }
}
