//
//  FirebaseClient.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 18/4/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import Firebase

class FirebaseClient {
    
    // MARK: Public methods to access Data from Firebase
    class func getLocations(completion: @escaping ([Location]?, Error?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            getLocationsList(uid: uid, dbRef: dbRef, completion: completion)
            getLocationsList(uid: uid, dbRef: dbRef) { (locations, error) in
                guard let locations = locations else {
                    completion(nil, error)
                    return
                }
                print("Locations: \(locations)")
                locations.forEach { (location) in
                    getStoragesList(uid: uid, locationId: location.id, dbRef: dbRef) { (storages, error) in
                        print("Storages: \(storages)")
                        storages?.forEach({ (storage) in
                            getItemsList(uid: uid, locationId: storage.locationId, storageId: storage.id, dbRef: dbRef) { (items, error) in
                                print("Items: \(items)")
                            }
                        })
                    }
                }
            }
        } else {
            completion(nil, nil)
        }
    }
    
    // MARK: Fetch data from Firebase
    private class func getLocationsList(uid: String, dbRef: DatabaseReference, completion: @escaping ([Location]?, Error?) -> Void) {
        let path = DatabaseCollection.location(uid: uid).path
        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let locationsDict = snapshot.value as? [String: AnyObject]
            var locations: [Location] = []
            
            locationsDict?.forEach({ (arg0) in
                let (locationId, locationObject) = arg0
                locations.append(mapLocationDictionaryToStruct(locationId, locationObject))
            })
            completion(locations, nil)
        }
    }
    
    private class func getStoragesList(uid: String, locationId: String, dbRef: DatabaseReference, completion: @escaping ([Storage]?, Error?) -> Void) {
        let path = "\(DatabaseCollection.storage(uid: uid).path)/\(locationId)"
        
        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let storagesDict = snapshot.value as? [String: AnyObject]
            var storages: [Storage] = []
            
            storagesDict?.forEach({ (arg0) in
                let(storageId, storageObject) = arg0
                storages.append(mapStorageDictionaryToStruct(storageId, storageObject))
            })
            completion(storages, nil)
        }
    }
    
    private class func getItemsList(uid: String, locationId: String, storageId: String, dbRef: DatabaseReference, completion: @escaping ([Item]?, Error?) -> Void) {
        let path = "\(DatabaseCollection.item(uid: uid).path)/\(locationId)/\(storageId)"

        dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            let itemsDict = snapshot.value as? [String: AnyObject]
            var items: [Item] = []

            itemsDict?.forEach({ (arg0) in
                let (itemId, itemObject) = arg0
                items.append(mapItemDictionaryToStruct(itemId, itemObject))
            })
            completion(items, nil)
        }
    }
    
    // MARK: Mappers to parse Firebase Dictionary Objects into local Structs
    private class func mapLocationDictionaryToStruct(_ locationId: String, _ locationObject: AnyObject) -> Location {
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
        
        return Location(id: locationId, name: name, subName: subName, description: description, imageUrl: imageUrl, type: type, subType: subType, tags: tags, createdAt: createdAt, updatedAt: updatedAt, storages: nil)
    }
    
    private class func mapStorageDictionaryToStruct(_ storageId: String, _ storageObject: AnyObject) -> Storage {
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
        
        return Storage(id: storageId, locationId: locationId, name: name, description: description, imageUrl: imageUrl, type: type, tags: tags, createdAt: createdAt, updatedAt: updatedAt, items: nil)
    }
    
    private class func mapItemDictionaryToStruct(_ itemId: String, _ itemObject: AnyObject) -> Item {
        let storageId: String = itemObject.value(forKey: DatabaseField.Common.storageId) as? String ?? ""
        let locationId: String = itemObject.value(forKey: DatabaseField.Common.locationId) as? String ?? ""
        let name: String = itemObject.value(forKey: DatabaseField.Common.name) as? String ?? ""
        let description: String? = itemObject.value(forKey: DatabaseField.Common.description) as? String
        let imageUrl: String? = itemObject.value(forKey: DatabaseField.Common.imageUrl) as? String
        let type: String = itemObject.value(forKey: DatabaseField.Common.type) as? String ?? ""
        let tags: [String]? = itemObject.value(forKey: DatabaseField.Common.tags) as? [String]
        let createdAtTimestamp: Double = itemObject.value(forKey: DatabaseField.Common.createdAt) as? Double ?? 0
        let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp)
        let updatedAtTimestamp: Double = itemObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
        let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp)

        return Item(id: itemId, storageId: storageId, locationId: locationId, name: name, description: description, imageUrl: imageUrl, type: type, tags: tags, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    // MARK: Database Collections and Field name Constants
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
}
