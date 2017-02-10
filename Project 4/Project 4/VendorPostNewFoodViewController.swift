//
//  VendorPostNewFoodViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/9/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorPostNewFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   // MARK: Definitions
   
   enum Sections: Int {
      case main = 0
      
      static var count = main.rawValue + 1
   }
   
   enum MainRows: Int {
      case foodTitle = 0
      case foodQuantity
      case foodDuration
      case foodLocation
      case foodAdditionalInfo
      case foodUploadImage
      case foodPostButton
      
      static var count = MainRows.foodPostButton.rawValue + 1
      
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var tableViewOutlet: UITableView!
   
   
   
   // MARK: Loading Functions
   override func viewDidLoad() {
      super.viewDidLoad()
      
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification: )), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
      
      tableViewOutlet.rowHeight = UITableViewAutomaticDimension
      tableViewOutlet.estimatedRowHeight = 44.0
      
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
      
      switch Sections(rawValue: indexPath.section)! {
      case .main:
         switch MainRows(rawValue: indexPath.row)! {
         case .foodTitle:
            let foodInfoCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodTitleTableViewCell", for: indexPath) as! VendorFoodTitleTableViewCell
            
            let foodTitle = foodInfoCell.foodTitleTextField.text
            cell = foodInfoCell
            
         case .foodQuantity:
            let foodQuantityCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodQuantityTableViewCell", for: indexPath) as! VendorFoodQuantityTableViewCell
            
            let foodQuantity = foodQuantityCell.foodQuantityTextField.text
            cell = foodQuantityCell
            
         case .foodDuration:
            let foodDurationCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodDurationTableViewCell", for: indexPath) as! VendorFoodDurationTableViewCell
            
            let foodDuration = foodDurationCell.foodDurationTextField.text
            cell = foodDurationCell
            
         case .foodLocation:
            let foodLocationCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodLocationTableViewCell", for: indexPath) as! VendorFoodLocationTableViewCell
            
            let foodLocation = foodLocationCell.foodLocationTextField.text
            cell = foodLocationCell
            
         case .foodAdditionalInfo:
            let FoodAdditionalInfoCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodAdditionalInfoTableViewCell", for: indexPath) as! VendorFoodAdditionalInfoTableViewCell
            
            let foodAdditionalInfo = FoodAdditionalInfoCell.foodAdditionalInfoTextField.text
            cell = FoodAdditionalInfoCell
            
         case .foodUploadImage:
            let foodUploadImageCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodUploadImageTableViewCell", for: indexPath) as! VendorFoodUploadImageTableViewCell
            
            cell = foodUploadImageCell
            
         case .foodPostButton:
            let foodPostButtonCell = tableView.dequeueReusableCell(withIdentifier: "VendorFoodPostButtonTableViewCell", for: indexPath) as! VendorFoodPostButtonTableViewCell
            
            cell = foodPostButtonCell
         }
      }
      return cell!
   }
   
   
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      switch MainRows(rawValue: indexPath.row)! {
      case .foodTitle:
         return 100
         
      case .foodQuantity:
         return 100
         
      case .foodDuration:

         return 100
      case .foodLocation:

         return 100
      case .foodAdditionalInfo:

         return 50
      case .foodUploadImage:

         return 100
      case .foodPostButton:
          return 50
         
      default:
         return 75
      }
   }
}
