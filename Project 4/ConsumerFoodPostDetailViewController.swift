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
      case generalFoodInfo = 0
      case vendorInfo
      case additionalInfo
      case messageToVendor
      case submitButton
      
      static var count = MainRows.submitButton.rawValue + 1
      
   }
   
   
   // MARK: Properties
   var currentPost: Post?
   var messageToVendor: String?
   var cellRef: ConsumerFoodPostDetailMessageToVendorTableViewCell? = nil
   
   
   // MARK: Outlets
   @IBOutlet weak var tableViewOutlet: UITableView!
   
   
   // MARK: Loading Functions
   override func viewDidLoad() {
      super.viewDidLoad()
      
      hideKeyboardWhenTappedAround()
      
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
         if let messageCell = cellRef {
            let consumerRequestSuccessfulVC = segue.destination as! ConsumerRequestSuccessfulViewController
            consumerRequestSuccessfulVC.messageToVendor = messageCell.messageToVendor
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
         case .generalFoodInfo:
            let generalFoodInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailGeneralFoodInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailGeneralFoodInfoTableViewCell
            
            generalFoodInfoCell.foodTitle.text! = currentPost.title
            generalFoodInfoCell.foodAmount.text! = currentPost.quantity
            generalFoodInfoCell.postImageURL = currentPost.imageURL
            generalFoodInfoCell.availableUntil.text! = currentPost.deadline.prettyLocaleFormattedShortWithTime
            
            cell = generalFoodInfoCell
         case .vendorInfo:
            let vendorInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailVendorInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailVendorInfoTableViewCell
            
            cell = vendorInfoCell
         case .additionalInfo:
            let additionalInfoCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailAdditionalInfoTableViewCell", for: indexPath) as! ConsumerFoodPostDetailAdditionalInfoTableViewCell
            
            additionalInfoCell.additionalDetails.text = currentPost.additionalInfo
            cell = additionalInfoCell
            
            
         case .messageToVendor:
            let messageToVendorCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailMessageToVendorTableViewCell", for: indexPath) as! ConsumerFoodPostDetailMessageToVendorTableViewCell

            cellRef = messageToVendorCell
            cell = messageToVendorCell
            
         case .submitButton:
            let submitButtonCell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailSubmitButtonTableViewCell", for: indexPath) as! ConsumerFoodPostDetailSubmitButtonTableViewCell
            
            
            cell = submitButtonCell
         }
      }
      return cell!
   }
   
   
   
   // To set custom cell heights
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      switch Sections(rawValue: indexPath.section)! {
      case .main:
         switch MainRows(rawValue: indexPath.row)! {
         case .generalFoodInfo:
            return 179
         case .vendorInfo:
            return 60
         case .additionalInfo:
            return 80
         case .messageToVendor:
            return 124
         case .submitButton:
            return 85
         }
      }
   }
   
   
   
   
   
}
