//
//  DataModel.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import Firebase

class DataModel {
   
   static let sharedInstance = DataModel()
   
   var foodVendor: FoodVendor?
   var consumer: Consumer?
   var post: Post?
}


class FoodVendor {
   
   var name: String
   var uID: String?
   var location: String
   var firebaseRef: FIRDatabaseReference?
   
   init(name: String, location: String) {
      self.name = name
      self.location = location
   }
   
   // Firebase Snapshot init
   init(snapshot: FIRDataSnapshot) {
      
      let vendorName = snapshot.childSnapshot(forPath: "name")
      name = vendorName.value as! String
      
      let vendorLocation = snapshot.childSnapshot(forPath: "location")
      location = vendorLocation.value as! String
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}

   
   class Consumer {
      
      var uID: String?
      var location: String
      var firebaseRef: FIRDatabaseReference?
      
      init(location: String) {
         self.location = location
      }
      
      // Firebase Snapshot init
      init(snapshot: FIRDataSnapshot) {
         
         let consumerLocation = snapshot.childSnapshot(forPath: "location")
         location = consumerLocation.value as! String
         
         uID = snapshot.key
         firebaseRef = snapshot.ref
      }
   }


class Post {
   
   var title: String
   var description: String
   var quantity: String
   var location: String
   var deadline: String
   var date: Date
   var status = "Open"
   var uID: String?
   var firebaseRef: FIRDatabaseReference?
   
   init(title: String, description: String, quantity: String, location: String, deadline: String, date: Date, status: String) {
      
      self.title = title
      self.description = description
      self.quantity = quantity
      self.location = location
      self.deadline = deadline
      self.date = date
      self.status = status
   }
   
   
   init(snapshot: FIRDataSnapshot) {
      let postTitle = snapshot.childSnapshot(forPath: "title")
      title = postTitle.value as! String
      
      let postDescription = snapshot.childSnapshot(forPath: "description")
      description = postDescription.value as! String
      
      let postQuantity = snapshot.childSnapshot(forPath: "quantity")
      quantity = postQuantity.value as! String
      
      let postLocation = snapshot.childSnapshot(forPath: "location")
      location = postLocation.value as! String
      
      let postDeadline = snapshot.childSnapshot(forPath: "deadline")
      deadline = postDeadline.value as! String
      
      let postDate = snapshot.childSnapshot(forPath: "datePosted")
      date = Date(timeIntervalSince1970: postDate.value as! Double)
      
      let postStatus = snapshot.childSnapshot(forPath: "status")
      status = postStatus.value as! String
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}





