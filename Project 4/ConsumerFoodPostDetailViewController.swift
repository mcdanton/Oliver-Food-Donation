//
//  ConsumerFoodPostDetailViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

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
         case .GeneralFoodInfo:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailGeneralFoodInfoTableViewCell", for: indexPath)
         case .VendorInfo:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailVendorInfoTableViewCell", for: indexPath)
         case .AdditionalInfo:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailAdditionalInfoTableViewCell", for: indexPath)
         case .MessageToVendor:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailMessageToVendorTableViewCell", for: indexPath)
         case .SubmitButton:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerFoodPostDetailSubmitButtonTableViewCell", for: indexPath)
         }
      }
      return cell!
   }
   
   
   
   
   
   
}
