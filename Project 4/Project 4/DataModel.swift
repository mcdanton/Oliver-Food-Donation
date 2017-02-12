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
   var request: Request?
}


class FoodVendor {
   
   var name: String
   var location: String
   var role: UserRole = .vendor
   var uID: String?
   var firebaseRef: FIRDatabaseReference?
   
   init(name: String, location: String, role: UserRole) {
      self.name = name
      self.location = location
      self.role = role
   }
   
   // Firebase Snapshot init
   init(snapshot: FIRDataSnapshot) {
      
      let vendorName = snapshot.childSnapshot(forPath: "name")
      name = vendorName.value as! String
      
      let vendorLocation = snapshot.childSnapshot(forPath: "location")
      location = vendorLocation.value as! String
      
      let vendorRole = snapshot.childSnapshot(forPath: "role")
      role = UserRole(rawValue: vendorRole.value as! String)!
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}

   
   class Consumer {
      
      var name: String
      var location: String
      var role: UserRole = .consumer
      var uID: String?
      var firebaseRef: FIRDatabaseReference?
      
      init(name: String, location: String, role: UserRole) {
         self.name = name
         self.location = location
         self.role = role
      }
      
      // Firebase Snapshot init
      init(snapshot: FIRDataSnapshot) {
         
         let consumerName = snapshot.childSnapshot(forPath: "name")
         name = consumerName.value as! String
         
         let consumerLocation = snapshot.childSnapshot(forPath: "location")
         location = consumerLocation.value as! String
         
         let consumerRole = snapshot.childSnapshot(forPath: "role")
         role = UserRole(rawValue: consumerRole.value as! String)!
         
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
   var vendor: String
   var uID: String?
   var firebaseRef: FIRDatabaseReference?
   
   init(title: String, additionalInfo: String, quantity: String, deadline: String, date: Date, status: PostStatus, vendor: String) {
      
      self.title = title
      self.additionalInfo = additionalInfo
      self.quantity = quantity
      self.deadline = deadline
      self.date = date
      self.status = status
      self.vendor = vendor
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
      
      let postVendor = snapshot.childSnapshot(forPath: "vendor")
      vendor = postVendor.value as! String
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}





class Request {
   
   var requester: String
   var foodRequested: String
   var requestDate: Date
   var requestMessage: String
   var pickupStatus: StatusOfPickup = .pending
   var requestStatus: StatusOfRequest = .pending
   var itemVendor: String
   var uID: String?
   var firebaseRef: FIRDatabaseReference?
   
   init(requester: String, foodRequested: String, requestDate: Date, requestMessage: String, pickupStatus: StatusOfPickup, requestStatus: StatusOfRequest, itemVendor: String) {
      
      self.requester = requester
      self.foodRequested = foodRequested
      self.requestDate = requestDate
      self.requestMessage = requestMessage
      self.pickupStatus = pickupStatus
      self.requestStatus = requestStatus
      self.itemVendor = itemVendor
   }
   
   
   init(snapshot: FIRDataSnapshot) {
      let requestedBy = snapshot.childSnapshot(forPath: "requestedBy")
      requester = requestedBy.value as! String
      
      let requestedItem = snapshot.childSnapshot(forPath: "foodRequested")
      foodRequested = requestedItem.value as! String
      
      let dateOfRequest = snapshot.childSnapshot(forPath: "dateRequested")
      requestDate = Date(timeIntervalSince1970: dateOfRequest.value as! Double)
      
      let message = snapshot.childSnapshot(forPath: "requestMessage")
      requestMessage = message.value as! String
      
      let statusOfRequest = snapshot.childSnapshot(forPath: "statusOfRequest")
      requestStatus = StatusOfRequest(rawValue: statusOfRequest.value as! String)!
      
      let statusOfPickup = snapshot.childSnapshot(forPath: "statusOfPickup")
      pickupStatus = StatusOfPickup(rawValue: statusOfPickup.value as! String)!
      
      let vendorOfItem = snapshot.childSnapshot(forPath: "itemVendor")
      itemVendor = vendorOfItem.value as! String
      
      uID = snapshot.key
      firebaseRef = snapshot.ref
   }
}


