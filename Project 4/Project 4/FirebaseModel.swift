//
//  FirebaseModel.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import GeoFire
import INTULocationManager


class FirebaseModel {
   
   // MARK: Properties
   static let sharedInstance = FirebaseModel()
   
   
   lazy var geoFire: GeoFire = {
      let geofireRef = FIRDatabase.database().reference(withPath: "locations")
      return GeoFire(firebaseRef: geofireRef)!
   }()
   
   
   
   // MARK: Vendor Signup
   func foodVendorSignup(name: String, location: String, emailTextField: String, passwordTextField: String, viewController: UIViewController, complete: @escaping (Bool) -> ()) {
      
      FIRAuth.auth()?.createUser(withEmail: emailTextField, password: passwordTextField, completion: { user, error in
         
         if error == nil {
            self.addFoodVendor(name: name, location: location)
            complete(user != nil)
         } else {
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            viewController.present(alertController, animated: true, completion: nil)
         }
      })
   }
   
   
   func addFoodVendor(name: String, location: String) {
      guard let user = FIRAuth.auth()?.currentUser else {
         return
      }
      
      let vendorRef = FIRDatabase.database().reference(withPath: "Food Vendor")
      let vendorChild = vendorRef.child(user.uid)
      
      let vendorName = vendorChild.child("name")
      vendorName.setValue(name)
      
      let vendorLocation = vendorChild.child("location")
      vendorLocation.setValue(location)
      
      let userRole = vendorChild.child("role")
      userRole.setValue("Vendor")
   }
   
   
   // MARK: Consumer Sign Up
   func consumerSignup(name: String, location: String, emailTextField: String, passwordTextField: String, viewController: UIViewController, complete: @escaping (Bool) -> ()) {
      
      FIRAuth.auth()?.createUser(withEmail: emailTextField, password: passwordTextField, completion: { user, error in
         
         if error == nil {
            self.addConsumer(name: name, location: location)
            complete(user != nil)
         } else {
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            viewController.present(alertController, animated: true, completion: nil)
         }
      })
   }
   
   
   func addConsumer(name: String, location: String) {
      guard let user = FIRAuth.auth()?.currentUser else {
         return
      }
      
      let consumerRef = FIRDatabase.database().reference(withPath: "Consumer")
      let consumerChild = consumerRef.child(user.uid)
      
      let consumerName = consumerChild.child("name")
      consumerName.setValue(name)
      
      let consumerLocation = consumerChild.child("location")
      consumerLocation.setValue(location)
      
      let userRole = consumerChild.child("role")
      userRole.setValue("Consumer")
   }
   
   // MARK: Login
   
   func login(email: String, password: String, viewController: UIViewController, complete: @escaping (Bool) -> ()) {
      FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak viewController] (user, error) in
         
         if user == nil {
            
            let alertController = UIAlertController(title: "Invalid Login", message: "Email/Password does not match", preferredStyle: .alert)
            let defaultStyle = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultStyle)
            viewController?.present(alertController, animated: true, completion: nil)
         } else {
            complete(user != nil)
         }
      })
   }
   
   
   
   // MARK: Food Postings
   
   func postFood(title: String, additionalInfo: String, quantity: String, deadline: String, date: Date, complete: @escaping (String) -> ()) {
      guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
      
      let foodRef = FIRDatabase.database().reference(withPath: "foodPosted")
      let foodChild = foodRef.childByAutoId()
      let postTitle = foodChild.child("title")
      postTitle.setValue(title)
      let postAdditionalInfo = foodChild.child("additionalInfo")
      postAdditionalInfo.setValue(additionalInfo)
      let postQuantity = foodChild.child("quantity")
      postQuantity.setValue(quantity)
      
      let postDeadline = foodChild.child("deadline")
      postDeadline.setValue(deadline)
      let postDate = foodChild.child("datePosted")
      postDate.setValue(date.timeIntervalSince1970)
      let postStatus = foodChild.child("status")
      postStatus.setValue("Open")
      let vendor = foodChild.child("vendor")
      vendor.setValue(currentUser)
      complete(String(describing: foodChild.key))
   }
   
   
   // MARK: Add Request To Firebase
   
   func addRequestToFirebase(vendorUID: String, requester: String, itemRequested: String, requestDate: Date, requestMessage: String, itemVendor: String) {
      let requestRef = FIRDatabase.database().reference(withPath: "requests")
      let requestChild = requestRef.child(vendorUID)
      
      let requesterName = requestChild.child("requestedBy")
      requesterName.setValue(requester)
      
      let requestedItem = requestChild.child("foodRequested")
      requestedItem.setValue(itemRequested)
      
      let dateOfRequest = requestChild.child("dateRequested")
      dateOfRequest.setValue(requestDate.timeIntervalSince1970)
      
      let message = requestChild.child("requestMessage")
      message.setValue(requestMessage)
      
      let statusOfRequest = requestChild.child("statusOfRequest")
      statusOfRequest.setValue("Pending Pick Up")
      
      let statusOfPickup = requestChild.child("statusOfPickup")
      statusOfPickup.setValue("Pending")
      
      let vendorOfItem = requestChild.child("itemVendor")
      vendorOfItem.setValue(itemVendor)
   }
   
   
   // MARK: Location Functions
   
   func addVendorLocation(foodPostingUID: String, title: String, additionalInfo: String, quantity: String, deadline: String, date: Date) {
      
      INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in
         
         guard let unwrappedSelf = self else { return }
         if let unwrappedLocation = location {
            let vendorLocation = location
            let key = foodPostingUID
            let locationLat = unwrappedLocation.coordinate.latitude
            let locationLong = unwrappedLocation.coordinate.longitude
            
            unwrappedSelf.geoFire.setLocation(CLLocation(latitude: locationLat, longitude: locationLong), forKey: key) { (error) in
               if (error != nil) {
                  print("An error occured: \(error)")
               } else {
                  print("Saved location successfully!")
               }
            }
         } else {
            print("location is nil")
         }
      })
   }
   
   
   func retrieveLocation(){
      guard let unwrappedAuthenticatedUserUID = FIRAuth.auth()?.currentUser?.uid  else { return }
      geoFire.getLocationForKey(unwrappedAuthenticatedUserUID, withCallback: { (location, error) in
         if (error != nil) {
            print("An error occurred getting the location for \(unwrappedAuthenticatedUserUID): \(error!.localizedDescription)")
         } else if (location != nil) {
            print("Location for \(unwrappedAuthenticatedUserUID) is: [\(location?.coordinate.latitude), \(location?.coordinate.longitude)]")
         } else {
            print("GeoFire does not contain a location for \(unwrappedAuthenticatedUserUID)")
         }
      })
   }
   
   
   
   // MARK: Queries
   
   func queryLocations(locationToQuery: CLLocation?, complete: @escaping ([Post]) -> ()) {
      var arrayOfLocationKeys = [String]()
      
      guard let unwrappedLocation = locationToQuery else { complete([]); return }
      let query = geoFire.query(at: unwrappedLocation, withRadius: 10.0)
      
      query?.observe(.keyEntered, with: { (locationKey, nil) in
         guard let unwrappedLocationKey = locationKey else { return }
         arrayOfLocationKeys.append(unwrappedLocationKey)
      })
      
      query?.observeReady({ [weak self] in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.matchFoodToArea(keysToSearch: arrayOfLocationKeys, complete: complete)
      })
      
      
   }
   
   
   func queryVendorPosts(searchPath: String, key:String, valueToSearch:String, success: @escaping ([Post]) -> ()) {
      var arrayOfPosts = [Post]()
      
      let updatesRef = FIRDatabase.database().reference(withPath: searchPath)
      let query = updatesRef.queryOrdered(byChild: key).queryEqual(toValue: valueToSearch)
      
      query.observeSingleEvent(of: .value, with: { snapshot in
         
         for post in snapshot.children {
            
            if let postSnapshot = post as? FIRDataSnapshot {
               let postInstance = Post(snapshot: postSnapshot)
               arrayOfPosts.append(postInstance)
            }
         }
         DispatchQueue.main.async {
            success(arrayOfPosts)
         }
      })
   }
   
   
   
   
   // MARK: Observe Functions
   
   func observePosts(success: @escaping ([Post]) -> ()) {
      var arrayOfPosts = [Post]()
      
      let databaseRef = FIRDatabase.database().reference()
      databaseRef.observeSingleEvent(of: .value, with: { snapshot in
         
         let allPostsSnapshot = snapshot.childSnapshot(forPath: "foodPosted")
         for singlePost in allPostsSnapshot.children {
            
            if let postSnapshot = singlePost as? FIRDataSnapshot {
               let postInstance = Post(snapshot: postSnapshot)
               arrayOfPosts.append(postInstance)
            }
         }
         DispatchQueue.main.async {
            success(arrayOfPosts)
         }
      })
   }
   
   
   func matchFoodToArea(keysToSearch: [String], complete: @escaping ([Post]) -> ()) {
      var arrayOfPosts = [Post]()
      
      let databaseRef = FIRDatabase.database().reference()
      databaseRef.observeSingleEvent(of: .value, with: { snapshot in
         
         let allPostsSnapshot = snapshot.childSnapshot(forPath: "foodPosted")
         
         for key in keysToSearch {
            if allPostsSnapshot.childSnapshot(forPath: key).exists() {
               let postInstance = Post(snapshot: allPostsSnapshot.childSnapshot(forPath: key))
               arrayOfPosts.append(postInstance)
            }
         }
         DispatchQueue.main.async {
            complete(arrayOfPosts)
         }
      })
   }
   
   
   
   func queryRequests(searchPath: String, key:String, valueToSearch:String, success: @escaping ([Request]) -> ()) {
      var arrayOfRequests = [Request]()
      
      let updatesRef = FIRDatabase.database().reference(withPath: searchPath)
      let query = updatesRef.queryOrdered(byChild: key).queryEqual(toValue: valueToSearch)
      
      query.observeSingleEvent(of: .value, with: { snapshot in
         
         for request in snapshot.children {
            
            if let requestSnapshot = request as? FIRDataSnapshot {
               let requestInstance = Request(snapshot: requestSnapshot)
               arrayOfRequests.append(requestInstance)
            }
         }
         DispatchQueue.main.async {
            success(arrayOfRequests)
         }
      })
   }
   
   
   //MARK: Firebase Storage
   
   func uploadImageToFirebase(data: Data, imageName: String) {
      
      let storageRef = FIRStorage.storage().reference()
      let imageRef = storageRef.child(imageName)
      
      let _ = imageRef.put(data, metadata: nil) { (metadata, error) in
         guard let metadata = metadata else {
            return
         }
         let downloadURL = metadata.downloadURL
      }
   }
   
   
   func downloadImage(name: String, complete: @escaping (UIImage?) -> ()) {
      
      let imageRef = FIRStorage.storage().reference(forURL: name)
      imageRef.data(withMaxSize: 1 * 1000024 * 1024) { data, error in
         
         if let data = data,
            let image = UIImage(data: data) {
            complete(image)
         } else {
            complete(nil)
         }
      }
   }
   
   
   
}




