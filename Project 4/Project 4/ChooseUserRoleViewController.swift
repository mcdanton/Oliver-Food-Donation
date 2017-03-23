//
//  ChooseUserRoleViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChooseUserRoleViewController: UIViewController {
   
   
   
   // MARK: View Loading

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
   
   // MARK: Prepare For Segue
   // Passes along role of user (Vendor or Consumer) to sign in page
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "SignInAsVendor" {
         let signUpPage = segue.destination as! UserSignupViewController
         signUpPage.userRole = "Vendor"
      } else if segue.identifier == "SignInAsConsumer" {
         let signUpPage = segue.destination as! UserSignupViewController
         signUpPage.userRole = "Consumer"
      }
   }
   
   
   // MARK: Unwind Segue
   
   @IBAction func noUserAccountPressed(_ sender: UIStoryboardSegue) {
   }

   

}
