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
   
   // MARK: Properties
   
   var allPosts = [DataModel.sharedInstance.post] {
      didSet {
         tableViewOutlet.reloadData()
      }
   }
   
   
   //MARK: Outlets
   
   @IBOutlet weak var tableViewOutlet: UITableView!
   
   
   
   
   
   
   //MARK: View Did Load
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      FirebaseModel.sharedInstance.queryVendorPosts(searchPath: "foodPosted", key: "vendor", valueToSearch: (FIRAuth.auth()?.currentUser?.uid)!, success: { [weak self] arrayOfPosts in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.allPosts = arrayOfPosts
      })
      
   
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   // MARK: Table View Protocol Functions
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return allPosts.count
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "VendorHomeTableViewCell", for: indexPath) as! VendorHomeTableViewCell
      
 
      
      cell.postTitle.text = allPosts[indexPath.row]?.title
      cell.postStatus.text = allPosts[indexPath.row]?.status.rawValue
      cell.postDate.text = allPosts[indexPath.row]?.date.prettyLocaleFormatted
            
      
      return cell
   }
   
   
   // MARK: Random Functions
   
   @IBAction func VendorPostSuccessfulVCToVendorHomeVC(_ sender: UIStoryboardSegue) {
   }
   
   
   

   
}


