//
//  VendorLoginViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UITextFieldDelegate {
   
   // MARK: Properties
   
   var userRole: String?
   var activeField: UITextField?

   //MARK: Outlets
   
   @IBOutlet weak var userEmailTF: UITextField!
   @IBOutlet weak var userPasswordTF: UITextField!
   @IBOutlet weak var scrollView: UIScrollView!
   
   //MARK: Actions
   
   @IBAction func dontHaveAccountPressed(_ sender: Any) {
      performSegue(withIdentifier: "NoUserAccountPressed", sender: self)
   }
   
   @IBAction func loginPressed(_ sender: Any) {
      
      if (userEmailTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Email", message: "Please enter company email", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (userPasswordTF?.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (userPasswordTF.text?.characters.count)! < 6 {
         let alertController = UIAlertController(title: "Invalid Password", message: "Password must be at least 6 characters long", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else {
         
         FirebaseModel.sharedInstance.login(email: userEmailTF.text!, password: userPasswordTF.text!, viewController: self, complete: { [weak self] success in
            guard let unwrappedSelf = self else { return }
            if let assignedUserRole = unwrappedSelf.userRole {
               if assignedUserRole == "Vendor" {
                  
                  UserDefaults.standard.set("Vendor", forKey: "userRole")
                  UserDefaults.standard.synchronize()
                  
                  unwrappedSelf.performSegue(withIdentifier: "ShowVendorHomeTabBarController", sender: unwrappedSelf)
                  
               } else if assignedUserRole == "Consumer" {
                  
                  UserDefaults.standard.set("Consumer", forKey: "userRole")
                  UserDefaults.standard.synchronize()
                  
                  unwrappedSelf.performSegue(withIdentifier: "ShowConsumerHomeTabBarController", sender: unwrappedSelf)
                  
               } else {
                  print("NO USER ROLE SELECTED")
                  let alertController = UIAlertController(title: "Sign In Issue", message: "There was an issue setting up your account. Please close the app and try again.", preferredStyle: .alert)
                  let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                  alertController.addAction(defaultAction)
                  unwrappedSelf.present(alertController, animated: true, completion: nil)
               }
            }
         })
      }
   }
   
   
   
   //MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      userEmailTF.delegate = self
      userPasswordTF.delegate = self
      
      registerForKeyboardNotifications()
      hideKeyboardWhenTappedAround()

   }
   
   
   // MARK: Adjust View For Keyboard
   
   func registerForKeyboardNotifications() {
      //Adding notifies on keyboard appearing
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func deregisterFromKeyboardNotifications() {
      //Removing notifies on keyboard appearing
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func keyboardWasShown(notification: NSNotification) {
      //Need to calculate keyboard exact size due to Apple suggestions
      self.scrollView.isScrollEnabled = true
      var info = notification.userInfo!
      let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
      let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
      
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      
      var aRect : CGRect = self.view.frame
      aRect.size.height -= keyboardSize!.height
      if let activeField = self.activeField {
         if (!aRect.contains(activeField.frame.origin)){
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
         }
      }
   }
   
   func keyboardWillBeHidden(notification: NSNotification) {
      //Once keyboard disappears, restore original positions
      var info = notification.userInfo!
      let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
      let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      self.view.endEditing(true)
      self.scrollView.isScrollEnabled = false
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      activeField = textField
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      activeField = nil
   }

   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      // Try to find next responder
      if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
         nextField.becomeFirstResponder()
      } else {
         // Not found, so remove keyboard.
         textField.resignFirstResponder()
      }
      // Do not add a line break
      return false
   }
   
   
}
