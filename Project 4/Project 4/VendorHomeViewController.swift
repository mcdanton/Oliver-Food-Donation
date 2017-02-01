//
//  VendorHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase

class VendorHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   // MARK: Table View Protocol Functions
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "VendorHomeTableViewCell", for: indexPath) as! VendorHomeTableViewCell
      
      return cell
   }
   

   
   
   
   
}
