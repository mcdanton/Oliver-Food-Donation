//
//  ConsumerFoodPostDetailViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ConsumerFoodPostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   // MARK: Definitions
   
   enum Sections: Int {
      case main = 0
      
      static var count = main.rawValue + 1
   }
   
   enum MainRows: Int {
      case GeneralFoodInfo = 0
      case VendorInfo
      case AdditionalInfo
      case MessageToVendor
      case SubmitButton
      
      static var count = MainRows.SubmitButton.rawValue + 1
      
   }
   
   
   // MARK: Properties
   
   var currentPost: Post?
   
   
   
   // MARK: Outlets
   @IBOutlet weak var tableViewOutlet: UITableView!
   
   
   // MARK: Loading Functions
   override func viewDidLoad() {
      super.viewDidLoad()
      
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification: )), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
   }
   
   
   // MARK: Keyboard Functions
   
   func keyboardDidShow(notification: Notification) {
      let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      let keyboardFrame = view.convert(frame, from: nil)
      var tableViewEdgeInsets = tableViewOutlet.contentInset
      tableViewEdgeInsets.bottom += keyboardFrame.height
      UIView.animate(withDuration: 0.25, animations: { [weak self] () -> Void in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.tableViewOutlet.contentInset = tableViewEdgeInsets
         unwrappedSelf.tableViewOutlet.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
      })
   }
   
   
   func keyboardDidHide(notification: Notification) {
      var noKeyboardInsets = tableViewOutlet.contentInset
      noKeyboardInsets.bottom = 30
      UIView.animate(withDuration: 0.25, animations: { [weak self] () -> Void in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.tableViewOutlet.contentInset = noKeyboardInsets
         unwrappedSelf.tableViewOutlet.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      })
   }
   
   
   // MARK: Prepare For Segue
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ConsumerFoodPostDetailVCToConsumerRequestSuccessfulVC" {
         if let currentPost = currentPost {
               let consumerRequestSuccessfulVC = segue.destination as! ConsumerRequestSuccessfulViewController
            consumerRequestSuccessfulVC.currentPost = currentPost

         }
      }
   }
   
   
   // MARK: Table View Functions
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch Sections(rawValue: section)! {
      case .main:
         return MainRows.count
      }
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return Sections.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell:UITableViewCell?
      guard let currentPost = currentPost else { return cell! }
      
      switch Sections(rawValue: indexPath.section)! {
      case .main:
         switch MainRows(rawValue: indexPath.row)! {
         case .GeneralFoodInfo:
            let generalFoodInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailGeneralFoodInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailGeneralFoodInfoTableViewCell
            
            generalFoodInfoCell.foodTitle.text! = currentPost.title
            generalFoodInfoCell.foodAmount.text! = currentPost.quantity
            cell = generalFoodInfoCell
         case .VendorInfo:
            let vendorInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailVendorInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailVendorInfoTableViewCell
            
            cell = vendorInfoCell
         case .AdditionalInfo:
            let additionalInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailAdditionalInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailAdditionalInfoTableViewCell
            
            additionalInfoCell.additionalDetails.text = currentPost.additionalInfo
            cell = additionalInfoCell
            
            
         case .MessageToVendor:
            let messageToVendorCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailMessageToVendorTableViewCell", for: indexPath) as! ConsumerFoodPostDetailMessageToVendorTableViewCell
            
            
            cell = messageToVendorCell
         case .SubmitButton:
            let submitButtonCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailSubmitButtonTableViewCell", for: indexPath) as! ConsumerFoodPostDetailSubmitButtonTableViewCell
            
            cell = submitButtonCell
         }
      }
      return cell!
   }
   
   
   
   
   
}
