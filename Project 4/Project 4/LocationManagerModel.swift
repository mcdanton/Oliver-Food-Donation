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
   
   static var locationAccessGranted : Bool {
      return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
   }
   
   static func requestLocationAccess() {
      manager.requestWhenInUseAuthorization()
   }
   
}
