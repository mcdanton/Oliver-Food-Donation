//
//  DataModel.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

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
   var additionalInfo: String
   var quantity: String
   var deadline: String
   var date: Date
   var status: PostStatus = .open
   var uID: String?
   var firebaseRef: FIRDatabaseReference?
   
   init(title: String, additionalInfo: String, quantity: String, deadline: String, date: Date, status: PostStatus) {
      
      self.title = title
      self.additionalInfo = additionalInfo
      self.quantity = quantity
      self.deadline = deadline
      self.date = date
      self.status = status
   }
   
   
   init(snapshot: FIRDataSnapshot) {
      let postTitle = snapshot.childSnapshot(forPath: "title")
      title = postTitle.value as! String
      
      let postadditionalInfo = snapshot.childSnapshot(forPath: "additionalInfo")
      additionalInfo = postadditionalInfo.value as! String
      
      let postQuantity = snapshot.childSnapshot(forPath: "quantity")
      quantity = postQuantity.value as! String
      
      let postDeadline = snapshot.childSnapshot(forPath: "deadline")
      deadline = postDeadline.value as! String
      
      let postDate = snapshot.childSnapshot(forPath: "datePosted")
      date = Date(timeIntervalSince1970: postDate.value as! Double)
      
      let postStatus = snapshot.childSnapshot(forPath: "status")
      status = PostStatus(rawValue: postStatus.value as! String)!
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}





