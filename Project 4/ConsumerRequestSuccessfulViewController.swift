//
//  ConsumerRequestSuccessfulViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/9/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ConsumerRequestSuccessfulViewController: UIViewController {
   
   // MARK: Properties
   
   var currentPost: Post?
   var messageToVendor: String?
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.navigationItem.hidesBackButton = true
      
      // If there is a current post, change the Post Status in Firebase from "Open" to "Pending", and add a request to the vendor for that food item in Firebase as well. Function includes protections to ensure the current post exists and its status is successfully updated in Firebase.
      if let currentPost = currentPost {
         
         let foodPostedRef = FIRDatabase.database().reference(withPath: "foodPosted").child(currentPost.uID!)
         foodPostedRef.updateChildValues(["status" : PostStatus.pending.rawValue], withCompletionBlock: { [weak self] (error, databaseReference) in
            
            if error == nil {
               
               FirebaseModel.sharedInstance.addRequestToFirebase(vendorUID: currentPost.uID!, requester: (FIRAuth.auth()?.currentUser?.email)!, itemRequested: currentPost.title, requestDate: Date(), requestMessage: self?.messageToVendor != nil ? (self?.messageToVendor)! : "I'd like to pick up this food please!", itemVendor: currentPost.vendor)
            } else {
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self?.present(alertController, animated: true, completion: nil)
            }
         })
      } else {
         let alertController = UIAlertController(title: "No Current Post", message: "There's no current food item showing up!", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
      dismissViewController()
   }
   
   
   // Used to bring Consumer back to home page after successful food request
   func dismissViewController() {
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
         self?.performSegue(withIdentifier: "ConsumerRequestSuccessfulVCToConsumerHomeVC", sender: self)
      })
   }
   
}
