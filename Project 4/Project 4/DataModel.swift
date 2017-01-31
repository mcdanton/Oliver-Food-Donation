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
}


class FoodVendor {
   
   var name: String
   var uID: String
   var location: String
   var firebaseRef: FIRDatabaseReference?
   
   init(name: String, uID: String, location: String) {
      self.name = name
      self.uID = uID
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
      
      var uID: String
      var location: String
      var firebaseRef: FIRDatabaseReference?
      
      init(uID: String, location: String) {
         self.uID = uID
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
  

