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
            
            getLocationsList(uid: uid, dbRef: dbRef) { (locations, error) in
                guard let locations = locations else {
                    completion(nil, error)
                    return
                }
                
                // mappedLocations list will be used to aggregate the responses of storages and items into their respective locations
                var mappedLocations: [Location] = locations
                
                for (locationIndex, location) in locations.enumerated() {
                    
                    getStoragesList(uid: uid, locationId: location.id, dbRef: dbRef) { (storages, error) in
                        // If there are no storages, we can simply return the locations list
                        guard let storages = storages else {
                            completion(mappedLocations, error)
                            return
                        }
                        
                        mappedLocations[locationIndex].storages = storages
                        
                        if (storages.isEmpty) {
                            completion(mappedLocations, error)
                        } else {
                            for (storageIndex, storage) in storages.enumerated() {
                                // Get items for each storage
                                getItemsList(uid: uid, locationId: storage.locationId, storageId: storage.id, dbRef: dbRef) { (items, error) in
                                    
                                    // Add the Location names and Storage names for convenience here to reduce future parsing
                                    let itemsWithLocationAndStorageNames: [Item]? = items?.map({ (item) -> Item in
                                        var newItem = item
                                        newItem.locationName = location.getDisplayName()
                                        newItem.storageName = storage.name
                                        return newItem
                                    })
                                    
                                    mappedLocations[locationIndex].storages?[storageIndex].items = itemsWithLocationAndStorageNames
                                    
                                    // If this is the last storage, return the mapped locations array to the completion handler
                                    if storageIndex == storages.count - 1 {
                                        completion(mappedLocations, nil)
                                    }
                                }
                            }
                        }
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
            completion(locations.isEmpty ? nil : locations, nil)
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
            completion(storages.isEmpty ? nil : storages, nil)
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
            completion(items.isEmpty ? nil : items, nil)
        }
    }
    
    // MARK: Create data in Firebase
    class func createLocation(location: Location, completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            
            let path = DatabaseCollection.location(uid: uid).path
            let fieldsDictionary = mapLocationStructToDictionary(location: location)
            print("Locations fields to add: \(fieldsDictionary)")
            
            dbRef.child(path).childByAutoId().setValue(fieldsDictionary) { (error, ref) in
                completion(error == nil)
            }
        } else {
            completion(false)
        }
    }
    
    class func createStorage(storage: Storage, completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            
            let path = "\(DatabaseCollection.storage(uid: uid).path)/\(storage.locationId)"
            let fieldsDictionary = mapStorageStructToDictionary(storage: storage)
            print("Storage fields to add: \(fieldsDictionary)")
            
            dbRef.child(path).childByAutoId().setValue(fieldsDictionary) { (error, ref) in
                completion(error == nil)
            }
        } else {
            completion(false)
        }
    }
    
    class func createItem(item: Item, completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            
            let path = "\(DatabaseCollection.item(uid: uid).path)/\(item.locationId)/\(item.storageId)"
            let fieldsDictionary = mapItemStructToDictionary(item: item)
            print("Item fields to add: \(fieldsDictionary)")
            
            dbRef.child(path).childByAutoId().setValue(fieldsDictionary) { (error, ref) in
                completion(error == nil)
            }
        } else {
            completion(false)
        }
    }
    
    // MARK: Mappers to parse Firebase Dictionary Objects into local Structs and vice versa
    private class func mapLocationDictionaryToStruct(_ locationId: String, _ locationObject: AnyObject) -> Location {
        let name: String = locationObject.value(forKey: DatabaseField.Common.name) as? String ?? ""
        let subName: String? = locationObject.value(forKey: DatabaseField.Location.subName) as? String
        let description: String? = locationObject.value(forKey: DatabaseField.Common.description) as? String
        let imageUrl: String? = locationObject.value(forKey: DatabaseField.Common.imageUrl) as? String
        let type: String = locationObject.value(forKey: DatabaseField.Common.type) as? String ?? ""
        let subType: String = locationObject.value(forKey: DatabaseField.Location.subType) as? String ?? ""
        let tags: [String]? = locationObject.value(forKey: DatabaseField.Common.tags) as? [String]
        let createdAtTimestamp: Double = locationObject.value(forKey: DatabaseField.Common.createdAt) as? Double ?? 0
        let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp/1000)
        let updatedAtTimestamp: Double = locationObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
        let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp/1000)
        
        return Location(id: locationId, name: name, subName: subName, description: description, imageUrl: imageUrl, type: type, subType: subType, tags: tags, createdAt: createdAt, updatedAt: updatedAt, storages: nil)
    }
    
    private class func mapLocationStructToDictionary(location: Location) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary[DatabaseField.Common.name] = location.name
        dictionary[DatabaseField.Location.subName] = location.subName
        dictionary[DatabaseField.Common.description] = location.description
        dictionary[DatabaseField.Common.imageUrl] = location.imageUrl ?? ""
        dictionary[DatabaseField.Common.type] = location.type
        dictionary[DatabaseField.Location.subType] = location.subType
        dictionary[DatabaseField.Common.tags] = location.tags ?? []
        dictionary[DatabaseField.Common.createdAt] = location.createdAt.currentTimeMillis()
        dictionary[DatabaseField.Common.updatedAt] = location.updatedAt.currentTimeMillis()
        
        return dictionary
    }
    
    private class func mapStorageDictionaryToStruct(_ storageId: String, _ storageObject: AnyObject) -> Storage {
        let locationId: String = storageObject.value(forKey: DatabaseField.Common.locationId) as? String ?? ""
        let name: String = storageObject.value(forKey: DatabaseField.Common.name) as? String ?? ""
        let description: String? = storageObject.value(forKey: DatabaseField.Common.description) as? String
        let imageUrl: String? = storageObject.value(forKey: DatabaseField.Common.imageUrl) as? String
        let type: String = storageObject.value(forKey: DatabaseField.Common.type) as? String ?? ""
        let tags: [String]? = storageObject.value(forKey: DatabaseField.Common.tags) as? [String]
        let createdAtTimestamp: Double = storageObject.value(forKey: DatabaseField.Common.createdAt) as? Double ?? 0
        let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp/1000)
        let updatedAtTimestamp: Double = storageObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
        let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp/1000)
        
        return Storage(id: storageId, locationId: locationId, name: name, description: description, imageUrl: imageUrl, type: type, tags: tags, createdAt: createdAt, updatedAt: updatedAt, items: nil)
    }
    
    private class func mapStorageStructToDictionary(storage: Storage) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary[DatabaseField.Common.name] = storage.name
        dictionary[DatabaseField.Common.description] = storage.description
        dictionary[DatabaseField.Common.imageUrl] = storage.imageUrl ?? ""
        dictionary[DatabaseField.Common.type] = storage.type
        dictionary[DatabaseField.Common.tags] = storage.tags ?? []
        dictionary[DatabaseField.Common.createdAt] = storage.createdAt.currentTimeMillis()
        dictionary[DatabaseField.Common.updatedAt] = storage.updatedAt.currentTimeMillis()
        
        return dictionary
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
        let createdAt: Date = Date(timeIntervalSince1970: createdAtTimestamp/1000)
        let updatedAtTimestamp: Double = itemObject.value(forKey: DatabaseField.Common.updatedAt) as? Double ?? 0
        let updatedAt: Date = Date(timeIntervalSince1970: updatedAtTimestamp/1000)

        return Item(id: itemId, storageId: storageId, storageName: nil, locationId: locationId, locationName: nil, name: name, description: description, imageUrl: imageUrl, type: type, tags: tags, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    private class func mapItemStructToDictionary(item: Item) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary[DatabaseField.Common.name] = item.name
        dictionary[DatabaseField.Common.description] = item.description
        dictionary[DatabaseField.Common.imageUrl] = item.imageUrl ?? ""
        dictionary[DatabaseField.Common.type] = item.type
        dictionary[DatabaseField.Common.tags] = item.tags ?? []
        dictionary[DatabaseField.Common.createdAt] = item.createdAt.currentTimeMillis()
        dictionary[DatabaseField.Common.updatedAt] = item.updatedAt.currentTimeMillis()
        
        return dictionary
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
