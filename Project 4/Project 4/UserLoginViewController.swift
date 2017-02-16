//
//  VendorLoginViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {
   
   // MARK: Properties
   
   var userRole: String?
   
   //MARK: Outlets
   
   @IBOutlet weak var userEmailTF: UITextField!
   @IBOutlet weak var userPasswordTF: UITextField!
   
   
   //MARK: Actions
   
   @IBAction func dontHaveAccountPressed(_ sender: Any) {
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
                  
                  unwrappedSelf.performSegue(withIdentifier: "ShowVendorHomeTabBarController", sender: unwrappedSelf)
                  
               } else if assignedUserRole == "Consumer" {
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
      hideKeyboardWhenTappedAround()

   }
   
   
}
