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
         consumerHomeTableViewOutlet.reloadData()
      }
   }
   
   
   
   // MARK: Outlets
   
   @IBOutlet weak var consumerHomeTableViewOutlet: UITableView!
   
   
   // MARK: Actions
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
      
      if LocationManagerModel.locationAccessGranted {

      INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in
         
         switch status {
         case .success:
            FirebaseModel.sharedInstance.queryLocations(locationToQuery: location, complete: { [weak self] posts in
               
               guard let unwrappedSelf = self else { return }
               unwrappedSelf.allPosts = posts
            })
         case .servicesDenied:
            guard let unwrappedSelf = self else { return }
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            unwrappedSelf.present(alertController, animated: true, completion: nil)
         case .servicesDisabled:
            guard let unwrappedSelf = self else { return }
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            unwrappedSelf.present(alertController, animated: true, completion: nil)
         case .servicesRestricted:
            guard let unwrappedSelf = self else { return }
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            unwrappedSelf.present(alertController, animated: true, completion: nil)
         case .timedOut:
            guard let unwrappedSelf = self else { return }
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            unwrappedSelf.present(alertController, animated: true, completion: nil)
         case .servicesNotDetermined:
            guard let unwrappedSelf = self else { return }
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            unwrappedSelf.present(alertController, animated: true, completion: nil)
         default:
            break
         }
      })
      
      } else {
         LocationManagerModel.requestLocationAccess()
         
      }
      
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
      
      cell.foodPostTitle.text = allPosts[indexPath.row]?.title
      
      
      return cell
   }
   

   
}
