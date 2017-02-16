//
//  ConsumerHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import INTULocationManager
import CoreLocation

class ConsumerHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
   
   // MARK: Properties
   
   var locationManager = CLLocationManager()
   
   var closer: (() -> Void)?
   
   
   // Determining Location Authorization Status
   var locationAccessNotYetAsked : Bool {
      return CLLocationManager.authorizationStatus() == .notDetermined
   }

   var locationAccessGranted : Bool {
      return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
   }
   

   var allPosts = [Post]() {
      didSet {
         
         allPosts = allPosts.filter() { $0.status == .open }
         consumerHomeTableViewOutlet.reloadData()
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var consumerHomeTableViewOutlet: UITableView!
   
   
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.navigationItem.hidesBackButton = true
   }
   
   
   // First checks to see if location auth was ever requested and requests it if not. If it was previously requested, will check the status of the location auth and in the case of authorized location will show all food posted in User's area while in the cases of unauthorized location will direct the user to change this in their settings.
   override func viewDidAppear(_ animated: Bool) {
      
      locationManager.delegate = self
      
      if locationAccessNotYetAsked {
         requestLocationAccess(complete: { success in
            if self.locationAccessGranted {

               INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in
                  
                  switch status {
                  case .success:
                     // Consider moving to the main thread - check INTULocation Manager Request Location function block for details
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
                     let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location. Please visit Settings > Privacy > Location Services to enable Location", preferredStyle: .alert)
                     let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                     alertController.addAction(action)
                     unwrappedSelf.present(alertController, animated: true, completion: nil)
                  case .timedOut:
                     guard let unwrappedSelf = self else { return }
                     let alertController = UIAlertController(title: "Location Request Timed Out", message: "We are having trouble accessing your location. Please try again.", preferredStyle: .alert)
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
               let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
               let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(action)
               self.present(alertController, animated: true, completion: nil)
            }
            
         })
      } else {
         if locationAccessGranted {

            INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in

               switch status {
               case .success:
                  // Consider moving to the main thread - check INTULocation Manager Request Location function block for details
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
                  let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location. Please visit Settings > Privacy > Location Services to enable Location", preferredStyle: .alert)
                  let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                  alertController.addAction(action)
                  unwrappedSelf.present(alertController, animated: true, completion: nil)
               case .timedOut:
                  guard let unwrappedSelf = self else { return }
                  let alertController = UIAlertController(title: "Location Request Timed Out", message: "We are having trouble accessing your location. Please try again.", preferredStyle: .alert)
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
            let alertController = UIAlertController(title: "Location Access Not Granted", message: "This app requires access to your location", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
         }

      }
      
      
   }
   
   
   // Used to bring Consumer back to home page after successful food request
   @IBAction func consumerRequestSuccessfulVCToConsumerHomeVC(_ sender: UIStoryboardSegue) {
   }
   
   
   
   
   
   // MARK: Table View Protocol Functions
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return allPosts.count
   }
   
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumerHomeTableViewCell", for: indexPath) as! ConsumerHomeTableViewCell
      
      cell.foodPostTitle.text = allPosts[indexPath.row].title
      cell.foodPostStatus.text = allPosts[indexPath.row].status.rawValue
      cell.postImageURL = allPosts[indexPath.row].imageURL
      
      return cell
   }
   
   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ConsumerHomeVCToConsumerFoodPostDetailVC" {
         if let indexPathRow = consumerHomeTableViewOutlet.indexPathForSelectedRow?.row {
            let consumerFoodPostDetailVC = segue.destination as! ConsumerFoodPostDetailViewController
            consumerFoodPostDetailVC.currentPost = allPosts[indexPathRow]
         } else {
            let alertController = UIAlertController(title: "No Current Post", message: "There's no current food item showing up!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
         }
      }
   }
   
   
   // MARK: Location Functions
   
   func requestLocationAccess(complete: @escaping ()->()) {
      closer = complete
      locationManager.requestWhenInUseAuthorization()
   }
   
   
   
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      
      if status == .authorizedWhenInUse {
         closer?()
      }
   }
   
}
