//
//  UserSignupViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class UserSignupViewController: UIViewController, UITextFieldDelegate {
   
   
   // MARK: Properties
   
   var userRole: String?
   var activeField: UITextField?

   
   // MARK: Outlets
   
   @IBOutlet weak var userNameTF: UITextField!
   @IBOutlet weak var userEmailTF: UITextField!
   @IBOutlet weak var userAddressTF: UITextField!
   @IBOutlet weak var userPasswordTF: UITextField!
   @IBOutlet weak var userConfirmPasswordTF: UITextField!
   @IBOutlet weak var registerButtonOutlet: UIButton!
   @IBOutlet weak var scrollView: UIScrollView!
   
   // MARK: Actions
   
   @IBAction func alreadyHaveAnAccountPressed(_ sender: Any) {
      
   }
   
   @IBAction func registerPressed(_ sender: Any) {
      validateVendor()
   }
   
   
   // MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      registerForKeyboardNotifications()
      hideKeyboardWhenTappedAround()
      
      userNameTF.delegate = self
      userEmailTF.delegate = self
      userAddressTF.delegate = self
      userPasswordTF.delegate = self
      userConfirmPasswordTF.delegate = self
   }
   

   
   // MARK: Sign In User
   
   func validateVendor() {
      
      if (userNameTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Name", message: "Please enter company name", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (userEmailTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Email", message: "Please enter company email", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (userAddressTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Address", message: "Please enter company address", preferredStyle: .alert)
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
      } else if (userConfirmPasswordTF?.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Confirm Password", message: "Please confirm your password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (userPasswordTF.text) != (self.userConfirmPasswordTF.text) {
         let alertController = UIAlertController(title: "Invalid Password", message: "Confirm password does not match password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else {
         
         if let assignedUserRole = userRole {
            if assignedUserRole == "Vendor" {
               FirebaseModel.sharedInstance.foodVendorSignup(name: userNameTF.text!, location: userAddressTF.text!, emailTextField: userEmailTF.text!, passwordTextField: userPasswordTF.text!, viewController: self, complete: { success in
                  
                  UserDefaults.standard.set("Vendor", forKey: "userRole")
                  UserDefaults.standard.synchronize()
                  
                  self.performSegue(withIdentifier: "ShowVendorHomeTabBarController", sender: self)
               })
               
            } else if assignedUserRole == "Consumer" {
               FirebaseModel.sharedInstance.consumerSignup(name: userNameTF.text!, location: userAddressTF.text!, emailTextField: userEmailTF.text!, passwordTextField: userPasswordTF.text!, viewController: self, complete: { success in
                  
                  UserDefaults.standard.set("Consumer", forKey: "userRole")
                  UserDefaults.standard.synchronize()
                  
                  self.performSegue(withIdentifier: "ShowConsumerHomeTabBarController", sender: self)
               })
            }
         } else {
            print("NO USER ROLE SELECTED")
            let alertController = UIAlertController(title: "Sign In Issue", message: "There was an issue setting up your account. Please close the app and try again.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
         }
      }
   }
   
   
   // MARK: Prepare For Segue
   
   // Passing along user type in case User has account and wants to log in
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowUserLoginVC" {
         let loginPage = segue.destination as! UserLoginViewController
         loginPage.userRole = userRole
      }
   }
   
   
   // MARK: Adjusting Screen For Keyboard
   
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
