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
import CoreLocation
import GeoFire
import INTULocationManager


class FirebaseModel {
   
   static let sharedInstance = FirebaseModel()
   
   
   lazy var geoFire: GeoFire = {
      let geofireRef = FIRDatabase.database().reference(withPath: "locations")
      return GeoFire(firebaseRef: geofireRef)!
   }()
   
   // MARK: Vendor Signup
   func FoodVendorSignup(name: String, location: String, emailTextField: String, passwordTextField: String, viewController: UIViewController, complete: @escaping (Bool) -> ()) {
      
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
      vendorName.setValue(location)
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
   
   func postFood(title: String, description: String, quantity: String, deadline: String, date: Date, complete: @escaping (String) -> ()) {
      guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
      
      let foodRef = FIRDatabase.database().reference(withPath: "foodPosted")
      let foodChild = foodRef.childByAutoId()
      let postTitle = foodChild.child("title")
      postTitle.setValue(title)
      let postDescription = foodChild.child("description")
      postDescription.setValue(description)
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
   
   
   // MARK: Location Functions
   
   func addVendorLocation(foodPostingUID: String, title: String, description: String, quantity: String, deadline: String, date: Date) {
      
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
   
   func queryLocations(locationToQuery: CLLocation, complete: @escaping ([Post]) -> ()) {
      var arrayOfLocationKeys = [String]()
      
      let query = geoFire.query(at: locationToQuery, withRadius: 0.6)
      
      query?.observe(.keyEntered, with: { (locationKey, nil) in
         guard let unwrappedLocationKey = locationKey else { return }
         arrayOfLocationKeys.append(unwrappedLocationKey)
      })
      
      query?.observeReady({ [weak self] in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.matchFoodToArea(keysToSearch: arrayOfLocationKeys, complete: complete)
      })
      
      
   }
   
   
   func queryLocation() {
      var locations = [CLLocation]()
      let center = CLLocation(latitude: 37.785834, longitude: -122.406417)
      // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
      var circleQuery = geoFire.query(at: center, withRadius: 0.6)
      
      // Query location by region
      let span = MKCoordinateSpanMake(0.001, 0.001)
      let region = MKCoordinateRegionMake(center.coordinate, span)
      var regionQuery = geoFire.query(with: region)
      
      for location in locations {
         print("HERE IS MORE LOCATION INFO is \(location)")
      }
      print("NO LOCATIONS RETURNED")
      
   }
   
   
   // MARK: Observe Functions
   
   func observePosts(success: @escaping ([Post]) -> ()) {
      var arrayOfPosts = [Post]()
      
      let databaseRef = FIRDatabase.database().reference()
      databaseRef.observeSingleEvent(of: .value, with: { snapshot in
         
         let allPostsSnapshot = snapshot.childSnapshot(forPath: "foodPosted")
         for singlePost in allPostsSnapshot.children {
            
            if let postSnapshot = singlePost as? FIRDataSnapshot {
               var postInstance = Post(snapshot: postSnapshot)
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
   
   
   
   
   
}




