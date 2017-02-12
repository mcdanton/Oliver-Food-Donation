//
//  UserSignupViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class UserSignupViewController: UIViewController {
   
   
   // MARK: Properties
   
   var userRole: String?
   
   // MARK: Outlets
   
   @IBOutlet weak var userNameTF: UITextField!
   @IBOutlet weak var userEmailTF: UITextField!
   @IBOutlet weak var userAddressTF: UITextField!
   @IBOutlet weak var userPasswordTF: UITextField!
   @IBOutlet weak var userConfirmPasswordTF: UITextField!
   @IBOutlet weak var registerButtonOutlet: UIButton!
   
   
   // MARK: Actions
   
   @IBAction func alreadyHaveAnAccountPressed(_ sender: Any) {
   }
   
   @IBAction func registerPressed(_ sender: Any) {
      validateVendor()
   }
   
   
   // MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      registerButtonOutlet.layer.borderColor = UIColor.white.cgColor
      registerButtonOutlet.layer.borderWidth = 1.0
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
                  
                  self.performSegue(withIdentifier: "ShowVendorHomeTabBarController", sender: self)                  
               })
               
            } else if assignedUserRole == "Consumer" {
               FirebaseModel.sharedInstance.consumerSignup(name: userNameTF.text!, location: userAddressTF.text!, emailTextField: userEmailTF.text!, passwordTextField: userPasswordTF.text!, viewController: self, complete: { success in
                  
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
         let loginPage = segue.destination as! UserLoginViewController
         loginPage.userRole = userRole
      }
   
   
   
}
