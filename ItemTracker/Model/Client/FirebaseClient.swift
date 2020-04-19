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
            static let name = "name"
            static let description = "description"
            static let imageUrl = "imageUrl"
            static let type = "type"
            static let tags = "tags"
            static let createdAt = "createdAt"
            static let updatedAt = "updatedAt"
            static let storageId = "storageId"
            static let locationId = "locationId"
        }

        struct User {
            static let email = "email"
            static let accountType = "accountType"
        }

        struct Location {
            static let subName = "subName"
            static let subType = "subType"
        }

        struct Types {
            static let location = "location"
            static let subLocation = "subLocation"
            static let locationTags = "locationTags"
            static let storage = "storage"
            static let item = "item"
            static let itemTags = "itemTags"
            static let accountType = "accountType"
        }
    }
    
    class func getLocations(completion: @escaping ([Location]?, Error?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            getLocationsList(uid: uid, dbRef: dbRef, completion: completion)
            getLocationsList(uid: uid, dbRef: dbRef) { (locations, error) in
                guard let locations = locations else {
                    completion(nil, error)
                    return
                }
                
                locations.forEach { (location) in
                    getStoragesList(uid: uid, locationId: location.id, dbRef: dbRef) { (storages, error) in
                        print("Storages: \(storages)")
                    }
                }
            }
        } else {
            completion(nil, nil)
        }
    }
    
    class func getLocationsList(uid: String, dbRef: DatabaseReference, completion: @escaping ([Location]?, Error?) -> Void) {
        let path = DatabaseCollection.location(uid: uid).path
        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let locationsDict = snapshot.value as? [String: AnyObject]
            var locations: [Location] = []
            
            locationsDict?.forEach({ (arg0) in
                let (locationId, locationObject) = arg0
                let name: String = locationObject.value(forKey: DatabaseField.Common.name) as? String ?? ""
                let subName: String? = locationObject.value(forKey: DatabaseField.Location.subName) as? String
                let description: String? = locationObject.value(forKey: DatabaseField.Common.description) as? String
                let imageUrl: String? = locationObject.value(forKey: DatabaseField.Common.imageUrl) as? String
                let type: String = locationObject.value(forKey: DatabaseField.Common.type) as? String ?? ""
                let subType: String = locationObject.value(forKey: DatabaseField.Location.subType) as? String ?? ""
                let tags: [String]? = locationObject.value(forKey: DatabaseField.Common.tags) as? [String]
                let createdAtTimestamp: Double = locationObject.value(forKey: DatabaseField.Common.createdAt) as? Double ?? 0
                let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp)
                let updatedAtTimestamp: Double = locationObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
                let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp)
                
                let location = Location(id: locationId, name: name, subName: subName, description: description, imageUrl: imageUrl, type: type, subType: subType, tags: tags, createdAt: createdAt, updatedAt: updatedAt, storages: nil)
                
                locations.append(location)
            })
            completion(locations, nil)
        }
    }
    
    class func getStoragesList(uid: String, locationId: String, dbRef: DatabaseReference, completion: @escaping ([Storage]?, Error?) -> Void) {
        let path = "\(DatabaseCollection.storage(uid: uid).path)/\(locationId)"
        
        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let storagesDict = snapshot.value as? [String: AnyObject]
            var storages: [Storage] = []
            
            storagesDict?.forEach({ (arg0) in
                let(storageId, storageObject) = arg0
                let locationId: String = storageObject.value(forKey: DatabaseField.Common.locationId) as? String ?? ""
                let name: String = storageObject.value(forKey: DatabaseField.Common.name) as? String ?? ""
                let description: String? = storageObject.value(forKey: DatabaseField.Common.description) as? String
                let imageUrl: String? = storageObject.value(forKey: DatabaseField.Common.imageUrl) as? String
                let type: String = storageObject.value(forKey: DatabaseField.Common.type) as? String ?? ""
                let tags: [String]? = storageObject.value(forKey: DatabaseField.Common.tags) as? [String]
                let createdAtTimestamp: Double = storageObject.value(forKey: DatabaseField.Common.createdAt) as? Double ?? 0
                let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp)
                let updatedAtTimestamp: Double = storageObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
                let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp)
                
                let storage = Storage(id: storageId, locationId: locationId, name: name, description: description, imageUrl: imageUrl, type: type, tags: tags, createdAt: createdAt, updatedAt: updatedAt, items: nil)
                
                storages.append(storage)
            })
            completion(storages, nil)
        }
    }
    
    class func getItemsList(uid: String, locationId: String, storageId: String, dbRef: DatabaseReference, completion: @escaping ([Item]?, Error?) -> Void) {
        
    }
}
