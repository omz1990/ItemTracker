//
//  Constants.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 17/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

struct Constants {
    
    struct Storyboard {
        static let Main = "Main"
    }
    
    struct StoryboardId {
        static let LoginController = "LoginNavigationController"
        static let MainTabsController = "MainTabBarController"
        static let AddNewViewController = "AddNewViewController"
    }

    struct Segues {
    }
    
    struct View {
        static let LocationCell = "locationCell"
        static let ItemRow = "itemTableRow"
        static let TypePickerView = "typePickerView"
        static let SubTypePickerView = "subTypePickerView"
    }
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }

    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoUrl"
        static let imageURL = "imageUrl"
    }
}
