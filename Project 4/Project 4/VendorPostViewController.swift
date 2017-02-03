//
//  VendorPostViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/2/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import CoreLocation

class VendorPostViewController: UIViewController {
   
   // MARK: Outlets
   
   @IBOutlet weak var postTitle: UITextField!
   @IBOutlet weak var quantity: UITextField!
   @IBOutlet weak var deadline: UITextField!
   @IBOutlet weak var postDescription: UITextField!
   @IBOutlet weak var location: UITextField!
   
   
   
   
   // MARK: Actions
   
   @IBAction func postButtonPressed(_ sender: Any) {
      
      FirebaseModel.sharedInstance.postFood(title: self.postTitle.text!, description: self.postDescription.text!, quantity: self.quantity.text!, deadline: self.deadline.text!, date: Date(), status: "Open")
      
      FirebaseModel.sharedInstance.addVendorLocation()
   
         self.view.alpha = 0
      
      
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
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
