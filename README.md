# ItemTracker

## App Overview:
This app allows users to track their things in an organised manner. Users can add a Location (like a room in a Building or an Apartment), and different storages available at that location (like cupboards and desks), and users can add different items in each storage. After that, users can easily search for their items and locations from the two tabs of the app for easy access.

### Overview
![Overview](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-Overview.png)

## Running the app (Instructions for Mac):
This app uses **CocoaPods** for different dependencies, make sure you have it installed. Directions [available here](https://cocoapods.org/#install).

Download or Clone this repository at a destination of your choice once CocoaPods are installed.

Open the Terminal app, and navigate to the project folder using the following command:
```sh
cd PATH_TO_PROJECT
```
Install the pods with the following command:
```sh
pod install
```
Once you see the success message, go into the project folder, and open **ItemTracker.xcworkspace**

***Build and run!***

# Data Structure:
Users can add multiple locations. Each location can have multiple storages. Each storage can have multiple items.
	
	User
		|__ Location
				|__ Storage
						|__ Item
						|__ Item
						|__ Item
				|__ Storage
						|__ Item
						|__ Item
		|__ Location
				|__ Storage
						|__ Item
				|__ Storage
						|__ Item
						|__ Item
		|__.....

## Signing in
The app allows Logging in through Gmail and also provides a fetaure to sign up and login with an Email address of your choice.

### Test user (login through email address):
> Email: testUser@itemtracker.com
> Password: theQuickBrownFox

### Login and Signup
![Account](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-Account.png)

## Main tabs:
The app has two main tabs:
- The Locations tab displays all the Locations with an overview of them in a CollectionView.
- The Items tab displays all the items in all locations in a single TableView.
- Both tabs have search functionalities, and the user can tap on them to view their details

### Location and Item Tabs (Empty and Filled States)
![Tabs](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-Tabs.png)

## Adding data:
There are two ways to add data. Here is some info to keep in mind:
- Both tabs have an Add Icon (+) on the top-left of the Navigation Bar which will allow the user to add data.
- The data entry is added sequentially based on the above mentioned Data structure.
- So when you add data, you will first be presented with an option to choose or create a Location, next step is to choose or create a Storage in the chosen location, and finally, the user is presented with an option to create an Item in the chosen storage.

### Add Data screens for all data types
![Add](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-Add.png)

## Viewing Data:
- All data types have Details screen. So if the user selects an existing data entry, they will be presented with the details screen where they can see more details about the chosen data.
- Location Details screen has a button to ***View or Add Storages***
- Storage Details screen has a button ***View or Add Items***

### Details screens for all data types
![Details](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-Detail.png)

## The "View or Add Screen"
- There is a **"View or Add"** screen for each data type.
- The Locations List Screen displays the current available Locations. Users can search and add more locations here.
- The Storages List Screen displays all the Storages in the chosen Location. Users can search and add more storages here.
- The Items List Screen displays all the Items in the chosen Storage. Users can search and add more items here.

### "View or Add Screen" for all data types
![List](https://www.ammologic.com/wp-content/uploads/2020/05/ItemTracker-List.png)

## Network API and Persistence:
The app uses **Firebase** Auth and Realtime Database, with Offline Persistence feature enabled.

## Known issue:
- Sometimes adding an Item inside a Storage doesn't reactively update the UI instantly after successful creation. If this happens, killing the app and opening again refreshes the caches and the newly created item is available.
