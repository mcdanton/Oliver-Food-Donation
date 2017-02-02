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

class FirebaseModel {
   
   static let sharedInstance = FirebaseModel()
   
   
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
   
   func postFood(title: String, description: String, quantity: String, location: String, deadline: String, date: Date, status: String) {
      guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
      
      let foodRef = FIRDatabase.database().reference(withPath: "foodPosted")
      let foodChild = foodRef.childByAutoId()
      let postTitle = foodChild.child("title")
      postTitle.setValue(title)
      let postDescription = foodChild.child("description")
      postDescription.setValue(description)
      let postQuantity = foodChild.child("quantity")
      postQuantity.setValue(quantity)
      let postLocation = foodChild.child("location")
      postLocation.setValue(location)
      let postDeadline = foodChild.child("deadline")
      postDeadline.setValue(deadline)
      let postDate = foodChild.child("datePosted")
      postDate.setValue(date.timeIntervalSince1970)
      let postStatus = foodChild.child("status")
      postStatus.setValue(status)
      let vendor = foodChild.child("vendor")
      vendor.setValue(currentUser)
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
   
   
   
   
}




