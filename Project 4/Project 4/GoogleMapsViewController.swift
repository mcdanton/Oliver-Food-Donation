//
//  GoogleMapsViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/21/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import INTULocationManager

class GoogleMapsViewController: UIViewController {
   
   // MARK: Properties
   
   var placesClient: GMSPlacesClient!
   
   var googleMapsView: GMSMapView!
   
   // MARK: Outlets
   
   @IBOutlet var containerView: UIView!

   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      
      self.googleMapsView = GMSMapView(frame: self.containerView.frame)
      self.view.addSubview(self.googleMapsView)
   }
   
   
   // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
   @IBOutlet var nameLabel: UILabel!
   @IBOutlet var addressLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      placesClient = GMSPlacesClient.shared()
   }
   
   // Add a UIButton in Interface Builder, and connect the action to this function.
   @IBAction func getCurrentPlace(_ sender: UIButton) {
      
      placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
         if let error = error {
            print("Pick Place error: \(error.localizedDescription)")
            return
         }
         
         self.nameLabel.text = "No current place"
         self.addressLabel.text = ""
         
         if let placeLikelihoodList = placeLikelihoodList {
            let place = placeLikelihoodList.likelihoods.first?.place
            if let place = place {
               self.nameLabel.text = place.name
               self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                  .joined(separator: "\n")
            }
         }
      })
   }
   


}
