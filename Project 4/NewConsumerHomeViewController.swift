//
//  NewConsumerHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/13/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import INTULocationManager
import CoreLocation

class NewConsumerHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegateFlowLayout {
   
   
   // MARK: Properties
   
   var locationManager = CLLocationManager()
   var closer: (() -> Void)?
   
   var allPosts = [Post]() {
      didSet {
         
         allPosts = allPosts.filter() { $0.status == .open }
         collectionViewOutlet.reloadData()
      }
   }
   
   // Determining Location Authorization Status
   var locationAccessNotYetAsked : Bool {
      return CLLocationManager.authorizationStatus() == .notDetermined
   }

   var locationAccessGranted : Bool {
      return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
   }
   
   
   
   // MARK: Outlets
   
   @IBOutlet weak var collectionViewOutlet: UICollectionView!
   
   
   // MARK: Actions
   
   @IBAction func signOutPressed(_ sender: Any) {
      FirebaseModel.sharedInstance.logout()
   }
   
   
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
                     FirebaseModel.sharedInstance.queryLocations(locationToQuery: location, complete: { [weak self] arrayOfPosts in
                        
                        guard let unwrappedSelf = self else { return }
                        
                        var workingArray = arrayOfPosts
                        
                        for (index, post) in workingArray.enumerated() {
                           
                           let workingPost = post
                           print("current post is \(post.title)")
                           
                           if post.deadline < Date() {
                              
                              FirebaseModel.sharedInstance.updateFoodPosting(child: post.uID!, completion: {
                                 
                                 print("Working array before removal: \(workingArray[0].title), \(workingArray[1].title), \(workingArray[2].title)")
                                 print("Working array before removal: \(workingArray[0].status.rawValue), \(workingArray[1].status.rawValue), \(workingArray[2].status.rawValue)")
                                 workingPost.status = .expired
                                 workingArray.remove(at: index)
                                 workingArray.insert(workingPost, at: index)
                                 print("Working array AFTER removal: \(workingArray[0].title), \(workingArray[1].title), \(workingArray[2].title)")
                                 print("Working array AFTER removal: \(workingArray[0].status.rawValue), \(workingArray[1].status.rawValue), \(workingArray[2].status.rawValue)")
                              })
                              
                           } else if post.deadline > Date() {
                              
                              
                              print("Deadline is past Current Date")
                           } else if post.deadline == Date() {
                              print("They're equal")
                           } else {
                              print("Something else")
                           }
                        }
                        
                        unwrappedSelf.allPosts = workingArray
                        
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
                  FirebaseModel.sharedInstance.queryLocations(locationToQuery: location, complete: { [weak self] arrayOfPosts in
                     
                     guard let unwrappedSelf = self else { return }
                     
                     var workingArray = arrayOfPosts
                     
                     for (index, post) in workingArray.enumerated() {
                        
                        let workingPost = post
                        print("current post is \(post.title)")
                        
                        if post.deadline < Date() {
                           
                           FirebaseModel.sharedInstance.updateFoodPosting(child: post.uID!, completion: {
                              
                              print("Working array before removal: \(workingArray[0].title), \(workingArray[1].title), \(workingArray[2].title)")
                              print("Working array before removal: \(workingArray[0].status.rawValue), \(workingArray[1].status.rawValue), \(workingArray[2].status.rawValue)")
                              workingPost.status = .expired
                              workingArray.remove(at: index)
                              workingArray.insert(workingPost, at: index)
                              print("Working array AFTER removal: \(workingArray[0].title), \(workingArray[1].title), \(workingArray[2].title)")
                              print("Working array AFTER removal: \(workingArray[0].status.rawValue), \(workingArray[1].status.rawValue), \(workingArray[2].status.rawValue)")
                           })
                           
                        } else if post.deadline > Date() {
                           
                           
                           print("Deadline is past Current Date")
                        } else if post.deadline == Date() {
                           print("They're equal")
                        } else {
                           print("Something else")
                        }
                     }

                     unwrappedSelf.allPosts = workingArray
                     
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
   
   
   
   
   
   // MARK: Collection View Protocol Functions
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return allPosts.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewConsumerHomeCollectionViewCell", for: indexPath) as! NewConsumerHomeCollectionViewCell
      
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOffset = CGSize(width: 5, height: 5)
      cell.layer.shadowOpacity = 1
      cell.layer.shadowRadius = 5
      cell.layer.masksToBounds = false
      cell.layer.cornerRadius = 10
      
      cell.foodPostTitle.text = allPosts[indexPath.row].title
      cell.foodPostStatus.text = allPosts[indexPath.row].status.rawValue
      cell.foodPostDate.text = allPosts[indexPath.row].date.prettyLocaleFormatted
      cell.postImageURL = allPosts[indexPath.row].imageURL
      
      return cell
   }
   

   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "NewConsumerHomeVCToConsumerFoodPostDetailVC" {
         let cell = sender as! NewConsumerHomeCollectionViewCell
         if let indexPathItem = collectionViewOutlet.indexPath(for: cell)?.row {
         let consumerFoodPostDetailVC = segue.destination as! ConsumerFoodPostDetailViewController
         consumerFoodPostDetailVC.currentPost = allPosts[indexPathItem]
         }
      } else {
            let alertController = UIAlertController(title: "No Current Post", message: "There's no current food item showing up!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
         }
      }
   
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      return CGSize(width: collectionView.bounds.size.width - 32, height: 148)
      
      
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
