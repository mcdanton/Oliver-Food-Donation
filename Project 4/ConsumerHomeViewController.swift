//
//  ConsumerHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import INTULocationManager

class ConsumerHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
   // MARK: Properties
   
   var allPosts = [DataModel.sharedInstance.post] {
      didSet {
      }
   }
   
   
   
   // MARK: Outlets
   
   
   
   
   // MARK: Actions
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

      INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in
      
         FirebaseModel.sharedInstance.queryLocations(locationToQuery: location!, complete: { posts in
            
            print("-------------------\(posts)")
            
         })
         
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
