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
   
   
   func updateVendor(child: String, logoURL: String, completion: () -> ()) {
      
      let vendorRef = FIRDatabase.database().reference(withPath: "Food Vendor").child(child)
      let vendorLogo = vendorRef.child("logoURL")
      vendorLogo.setValue(logoURL)
      
      completion()
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
   
   
   func updateConsumer(child: String, logoURL: String, completion: () -> ()) {
      
      let consumerRef = FIRDatabase.database().reference(withPath: "Consumer").child(child)
      let consumerLogo = consumerRef.child("logoURL")
      consumerLogo.setValue(logoURL)
      
      completion()
   }
   
   
   // MARK: Login & Logout
   
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
   
   
   func logout() {
      
      do {
         try FIRAuth.auth()?.signOut()
         
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
         let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
         
         appDelegate.window?.rootViewController = initialViewController
         appDelegate.window?.makeKeyAndVisible()
      } catch {
         print(error)
      }
   }
   
   
   
   // MARK: Food Postings
   
   func postFood(title: String, additionalInfo: String, quantity: String, deadline: Date, date: Date, imageURL: String, complete: @escaping (String) -> ()) {
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
      postDeadline.setValue(deadline.timeIntervalSince1970)
      let postDate = foodChild.child("datePosted")
      postDate.setValue(date.timeIntervalSince1970)
      let postStatus = foodChild.child("status")
      postStatus.setValue("Open")
      let vendor = foodChild.child("vendor")
      vendor.setValue(currentUser)
      let urlOfImage = foodChild.child("imageURL")
      urlOfImage.setValue(imageURL)
      
      complete(String(describing: foodChild.key))
   }
   
   func updateFoodPosting(child: String, completion: () -> ()) {
      
      let foodPostedRef = FIRDatabase.database().reference(withPath: "foodPosted").child(child)
      foodPostedRef.updateChildValues(["status" : PostStatus.expired.rawValue], withCompletionBlock: { (error, databaseReference) in
         
         if error != nil {
            print(error!.localizedDescription)
         } else {
            print("worked!")
         }
      })
      completion()
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
      statusOfRequest.setValue("Pending")
      
      let statusOfPickup = requestChild.child("statusOfPickup")
      statusOfPickup.setValue("Pending Pick Up")
      
      let vendorOfItem = requestChild.child("itemVendor")
      vendorOfItem.setValue(itemVendor)
   }
   
   
   // MARK: Location Functions
   
   func addVendorLocation(foodPostingUID: String) {
      
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
   
   // Retrieves an array of keys for all locations within a given radius of the searched location. The location keys are then passed into the MatchFoodToArea function to get the relevant Food Posts associated with each location. This is what is returned in the completion handler. This function is used to get all food posted within a given radius of a Food Bank.
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
   
   
   
   func queryVendorLocation(postLocationToQuery: String, complete: @escaping (CLLocation) -> ()) {
      var foodLocation: CLLocation?
      
      let databaseRef = FIRDatabase.database().reference(withPath: "locations")
      databaseRef.child(postLocationToQuery).observeSingleEvent(of: .value, with: { snapshot in
         
         let locationKey = snapshot.value as! NSDictionary
         let location = locationKey["l"] as! [Double]
         let latitude = location[0] 
         let longitude = location[1] 
         
         foodLocation = CLLocation(latitude: latitude, longitude: longitude)
         
         if let foodLocationExists = foodLocation {
            complete(foodLocationExists)
         }
      }) { (error) in
         print(error.localizedDescription)
      }
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
   
   func observeVendor(vendorToObserve: String, success: @escaping (FoodVendor?) -> ()) {
      var selectedVendor: FoodVendor?
      
      let databaseRef = FIRDatabase.database().reference()
      databaseRef.observeSingleEvent(of: .value, with: { snapshot in
         
         let allVendorsSnapshot = snapshot.childSnapshot(forPath: "Food Vendor")
         if allVendorsSnapshot.childSnapshot(forPath: vendorToObserve).exists() {
            
            let vendorInstance = FoodVendor(snapshot: allVendorsSnapshot.childSnapshot(forPath: vendorToObserve))
            selectedVendor = vendorInstance
         }
         DispatchQueue.main.async {
            success(selectedVendor)
         }
      })
   }
   
   
   func observeConsumer(consumerToObserve: String, success: @escaping (Consumer?) -> ()) {
      var selectedConsumer: Consumer?
      
      let databaseRef = FIRDatabase.database().reference()
      databaseRef.observeSingleEvent(of: .value, with: { snapshot in
         
         let allConsumersSnapshot = snapshot.childSnapshot(forPath: "Consumer")
         if allConsumersSnapshot.childSnapshot(forPath: consumerToObserve).exists() {
            
            let consumerInstance = Consumer(snapshot: allConsumersSnapshot.childSnapshot(forPath: consumerToObserve))
            selectedConsumer = consumerInstance
         }
         DispatchQueue.main.async {
            success(selectedConsumer)
         }
      })
   }
   
   
   
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




