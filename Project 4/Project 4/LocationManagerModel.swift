//
//  LocationManagerModel.swift
//  Project 4
//
//  Created by Dan Hefter on 2/3/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationManagerModel {
   
   static let manager = CLLocationManager()
   
   var closer: () -> Void?
   
   // MARK: Determining Location Authorization Status
   
   static var locationAccessNotYetAsked : Bool {
      return CLLocationManager.authorizationStatus() == .notDetermined
   }
   
   
   static var locationAccessGranted : Bool {
      return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
   }
   
   static func requestLocationAccess() {
      manager.requestWhenInUseAuthorization()
   }
   
   
   
   static func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      
      if status == .authorizedWhenInUse {

      }
   }

   static func wasLocationRequested(complete: () -> ()) {
      
      if locationAccessNotYetAsked {
         LocationManagerModel.requestLocationAccess()
      } else {
      }
   }
   
}
