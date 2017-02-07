//
//  ConsumerHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class ConsumerHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
   // MARK: Properties
   
   var allPosts = [DataModel.sharedInstance.post] {
      didSet {
         tableViewOutlet.reloadData()
      }
   }
   
   
   
   // MARK: Outlets
   
   
   
   
   // MARK: Actions
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

      LocationManagerModel.sharedInstance.getLocation(complete: { myLocation in
         FirebaseModel.sharedInstance.queryLocations(locationToQuery: myLocation)
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerHomeTableViewCell", for: indexPath) as! ConsumerHomeTableViewCell
      
      
      
      
      return cell
   }
   

   
}
