//
//  VendorRequestsCollectionViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/10/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class VendorRequestsCollectionViewCell: UICollectionViewCell {
   
   // MARK: Properties
   
   var currentRequest: Request?
   let vendorRequestsVC = VendorRequestsViewController()
   
   
   // MARK: Outlets
   
   @IBOutlet weak var foodTitle: UILabel!
   @IBOutlet weak var requestDate: UILabel!
   @IBOutlet weak var requestMessage: UILabel!
   @IBOutlet weak var requestStatus: UILabel!
   @IBOutlet weak var pickupStatus: UILabel!
   @IBOutlet weak var actionView: UIView!
   @IBOutlet weak var requester: UILabel!
   @IBOutlet weak var noOpenRequestsView: UIView!
   
   
   // MARK: Actions
   
   @IBAction func approveRequestPressed(_ sender: Any) {
      
      if let currentRequest = currentRequest {
         
         let foodRequestRef = FIRDatabase.database().reference(withPath: "requests").child(currentRequest.uID!)
         foodRequestRef.updateChildValues(["statusOfRequest" : StatusOfRequest.approved.rawValue], withCompletionBlock: { [weak self] (error, databaseReference) in
            
            self?.actionView.alpha = 0.0
            self?.requestStatus.text = "Approved"
            
            if error != nil {
               
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self?.vendorRequestsVC.present(alertController, animated: true, completion: nil)
            }
            let foodPostRef = FIRDatabase.database().reference(withPath: "foodPosted").child(currentRequest.uID!)
            foodPostRef.updateChildValues(["status" : PostStatus.awaitingPickup.rawValue],  withCompletionBlock: { [weak self] (error, databaseReference) in
               
               if error != nil {
                  
                  let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                  
                  let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                  alertController.addAction(defaultAction)
                  
                  self?.vendorRequestsVC.present(alertController, animated: true, completion: nil)
               }
            })
         })
      }
   }
   
   @IBAction func rejectRequestPressed(_ sender: Any) {
      if let currentRequest = currentRequest {
         
         let foodRequestRef = FIRDatabase.database().reference(withPath: "requests").child(currentRequest.uID!)
         foodRequestRef.updateChildValues(["statusOfRequest" : StatusOfRequest.rejected.rawValue], withCompletionBlock: { [weak self] (error, databaseReference) in
            
            self?.actionView.alpha = 0.0
            self?.requestStatus.text = "Rejected"
            
            
            if error != nil {
               
               let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               self?.vendorRequestsVC.present(alertController, animated: true, completion: nil)
            }
            let foodPostRef = FIRDatabase.database().reference(withPath: "foodPosted").child(currentRequest.uID!)
            foodPostRef.updateChildValues(["status" : PostStatus.open.rawValue],  withCompletionBlock: { [weak self] (error, databaseReference) in
               
               if error != nil {
                  
                  let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                  
                  let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                  alertController.addAction(defaultAction)
                  
                  self?.vendorRequestsVC.present(alertController, animated: true, completion: nil)
               }
            })
         })
      }
   }
   
}
