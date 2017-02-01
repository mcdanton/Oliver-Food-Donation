//
//  VendorSignupViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorSignupViewController: UIViewController {
   
   
   //MARK: Outlets

   @IBOutlet weak var vendorNameTF: UITextField!
   @IBOutlet weak var vendorEmailTF: UITextField!
   @IBOutlet weak var vendorAddressTF: UITextField!
   @IBOutlet weak var vendorPasswordTF: UITextField!
   @IBOutlet weak var vendorConfirmPasswordTF: UITextField!
   @IBOutlet weak var registerButtonOutlet: UIButton!
   
   
   //MARK: Actions
   
   @IBAction func signInAsUserPressed(_ sender: Any) {
      
   }
   
   @IBAction func alreadyHaveAnAccountPressed(_ sender: Any) {
   }
   
   @IBAction func registerPressed(_ sender: Any) {
      validateVendor()
      
   }
   
   
   //MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      registerButtonOutlet.layer.borderColor = UIColor.white.cgColor
      registerButtonOutlet.layer.borderWidth = 1.0
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   //MARK: Additional Functions
   
   func validateVendor() {
      
      if (vendorNameTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Name", message: "Please enter company name", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorEmailTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Email", message: "Please enter company email", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorAddressTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Address", message: "Please enter company address", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorPasswordTF?.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorPasswordTF.text?.characters.count)! < 6 {
         let alertController = UIAlertController(title: "Invalid Password", message: "Password must be at least 6 characters long", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorConfirmPasswordTF?.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Confirm Password", message: "Please confirm your password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (vendorPasswordTF.text) != (self.vendorConfirmPasswordTF.text) {
         let alertController = UIAlertController(title: "Invalid Password", message: "Confirm password does not match password", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else {
         FirebaseModel.sharedInstance.FoodVendorSignup(name: vendorNameTF.text!, location: vendorAddressTF.text!, emailTextField: vendorEmailTF.text!, passwordTextField: vendorPasswordTF.text!, viewController: self, complete: { success in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vendorHomeVC = storyboard.instantiateViewController(withIdentifier :"VendorHomeViewController") as! VendorHomeViewController
            self.present(vendorHomeVC, animated: true)

            
         })
      }
   }
   
   
   
}
