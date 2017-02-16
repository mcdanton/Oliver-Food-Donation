//
//  VendorPostSuccessfulViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/2/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorPostSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      dismissViewController()
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   // MARK: Other Functions
   
   func dismissViewController() {
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
         self?.performSegue(withIdentifier: "VendorPostSuccessfulVCToVendorHomeVC", sender: self)
      })
   }
   
   
}
