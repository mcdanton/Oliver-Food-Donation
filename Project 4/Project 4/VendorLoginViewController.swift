//
//  VendorLoginViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorLoginViewController: UIViewController {
   
   //MARK: Outlets
   
   @IBOutlet weak var vendorEmailTF: UITextField!
   @IBOutlet weak var vendorPasswordTF: UITextField!
   
   
   //MARK: Actions
   
   @IBAction func dontHaveAccountPressed(_ sender: Any) {
   }
   
   @IBAction func loginPressed(_ sender: Any) {
      
      if (vendorEmailTF.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Invalid Email", message: "Please enter company email", preferredStyle: .alert)
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
      } else {
         
         FirebaseModel.sharedInstance.login(email: vendorEmailTF.text!, password: vendorPasswordTF.text!, viewController: self, complete: { [weak self] success in
            guard let unwrappedSelf = self else { return }
            unwrappedSelf.performSegue(withIdentifier: "showVendorHomeTabBarController", sender: unwrappedSelf)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let unwrappedvendorHomeVC = storyboard.instantiateViewController(withIdentifier :"VendorHomeViewController") as? VendorHomeViewController ?? nil else { return }
//            unwrappedSelf.present(unwrappedvendorHomeVC, animated: true)
         })
      }
   }
   
   
   
   //MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
