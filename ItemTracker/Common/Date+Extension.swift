//
//  Date+Extension.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 4/5/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
