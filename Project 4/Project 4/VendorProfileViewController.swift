//
//  VendorProfileViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/12/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class VendorProfileViewController: UIViewController {
   
   
   // MARK: Outlets
   
   @IBOutlet weak var companyName: UILabel!
   @IBOutlet weak var companyEmail: UILabel!
   @IBOutlet weak var companyAddress: UILabel!
   
   
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
      
      companyEmail.text = FIRAuth.auth()?.currentUser?.email
      companyName.text = FIRAuth.auth()?.currentUser?.displayName
      
   }

    

   

}
