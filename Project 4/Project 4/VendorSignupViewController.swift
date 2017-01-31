//
//  VendorSignupViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorSignupViewController: UIViewController {
   
   
   //MARK: ------------ Outlets --------------------------------------
   
   @IBOutlet weak var vendorNameTF: UITextField!
   @IBOutlet weak var vendorEmailTF: UITextField!
   @IBOutlet weak var vendorAddressTF: UITextField!
   @IBOutlet weak var vendorPasswordTF: UITextField!
   @IBOutlet weak var vendorConfirmPasswordTF: UITextField!
   @IBOutlet weak var registerButtonOutlet: UIButton!
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

      registerButtonOutlet.layer.borderColor = UIColor.white.cgColor
      registerButtonOutlet.layer.borderWidth = 1.0
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
