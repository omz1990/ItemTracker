//
//  Location.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 18/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Foundation

struct Location {
    let id: String
    let name: String
    let subName: String?
    let description: String?
    let imageUrl: String?
    let type: String
    let subType: String
    let tags: [String]?
    let createdAt: Date
    let updatedAt: Date
    var storages: [Storage]?
}
