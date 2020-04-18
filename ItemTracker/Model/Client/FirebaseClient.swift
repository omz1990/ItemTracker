//
//  FirebaseClient.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 18/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Firebase

class FirebaseClient {
    
    enum DatabaseCollection {
        case users(uid: String)
        case location(uid: String)
        case storage(uid: String)
        case item(uid: String)
        case types
        
        var path: String {
            switch self {
            case .users(let uid): return "users/\(uid)"
            case .location(let uid): return "location/\(uid)"
            case .storage(let uid): return "storage/\(uid)"
            case .item(let uid): return "item/\(uid)"
            case .types: return "types"
            }
        }
    }
    
    struct DatabaseField {
        struct Common {
            let name = "name"
            let description = "description"
            let imageUrl = "imageUrl"
            let type = "type"
            let tags = "tags"
            let createdAt = "createdAt"
            let updatedAt = "updatedAt"
            let storageId = "storageId"
            let locationId = "locationId"
        }

        struct User {
            let email = "email"
            let accountType = "accountType"
        }

        struct Location {
            let subType = "subType"
        }

        struct Types {
            let location = "location"
            let subLocation = "subLocation"
            let locationTags = "locationTags"
            let storage = "storage"
            let item = "item"
            let itemTags = "itemTags"
            let accountType = "accountType"
        }
    }
    
    class func getLocations(completion: @escaping ([Location]?, Error?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            getLocationsList(uid: uid, dbRef: dbRef, completion: completion)
        } else {
            completion(nil, nil)
        }
    }
    
    class func getLocationsList(uid: String, dbRef: DatabaseReference, completion: @escaping ([Location]?, Error?) -> Void) {
        let path = DatabaseCollection.location(uid: uid).path
        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let locationsDict = snapshot.value as? [String: AnyObject]
            print("getLocationsList: \(locationsDict)")
        }
    }
    
    class func getStoragesList(uid: String, dbRef: DatabaseReference, completion: @escaping ([Storage]?, Error?) -> Void) {
        
    }
    
    class func getItemsList(uid: String, dbRef: DatabaseReference, completion: @escaping ([Item]?, Error?) -> Void) {
        
    }
}
