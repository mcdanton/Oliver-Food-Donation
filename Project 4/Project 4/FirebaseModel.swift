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
   
   
   // MARK: Firebase Signups
   func FoodVendorSignup(name: String, location: String, emailTextField: String, passwordTextField: String, viewController: ViewController) {
      
      FIRAuth.auth()?.createUser(withEmail: emailTextField, password: passwordTextField, completion: { user, error in
      
         if error == nil {
            self.addFoodVendor(name: name, location: location)
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
   
   
   
   
}
