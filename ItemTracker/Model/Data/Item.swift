//
//  Item.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 18/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation

struct Item {
    let id: String
    let storageId: String
    let locationId: String
    let name: String
    let description: String?
    let imageUrl: String?
    let type: String
    let tags: [String]?
    let createdAt: Date
    let updatedAt: Date
}
