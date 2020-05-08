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
        static let SelectViewController = "SelectViewController"
        static let DetailsViewController = "DetailsViewController"
    }

    struct Segues {
    }
    
    struct View {
        static let LocationCell = "locationCell"
        static let ItemRow = "itemTableRow"
        static let TypePickerView = "typePickerView"
        static let SubTypePickerView = "subTypePickerView"
        static let OverviewTableView = "OverviewTableViewCell"
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
    
    struct ErrorMessage {
        static let incompleteFieldsTile = "Incomplete fields"
        static let incompleteFieldsBody = "Please fill out all required fields underlined as red!"
    }
    
    struct Image {
        static let locationPlaceholder = "locationPlaceholder"
        static let storagePlaceholder = "storagePlaceholder"
        static let itemPlaceholder = "itemBoxPlaceholder"
    }
}
