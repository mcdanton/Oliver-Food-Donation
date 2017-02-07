//
//  LocationManagerModel.swift
//  Project 4
//
//  Created by Dan Hefter on 2/3/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManagerModel: NSObject, CLLocationManagerDelegate {
   
   // MARK: Singleton
   
   static let sharedInstance = LocationManagerModel()
   
   // MARK: Instance Properties and Init
   
   let locationManager = CLLocationManager()
   var currentLocation: CLLocation?
   
   
   var closure: ((CLLocation)->())?

   private override init() {
      super.init()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
      locationManager.requestWhenInUseAuthorization()
   }
   
   
   func getLocation(complete: @escaping (CLLocation)->()) {
      
      closure = complete
      locationManager.requestLocation()
   }
   
   
   // MARK: Instance Functions
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
      guard !locations.isEmpty,
         let unwrappedlocation = locations.first else { return }
      
      currentLocation = unwrappedlocation
      
      closure?(currentLocation!)
      
      let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
      let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(unwrappedlocation.coordinate.latitude, unwrappedlocation.coordinate.longitude)
      let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
   }
   
   
   func updateMap() {
      guard let unwrappedCurrentLocation = currentLocation else { return }
      let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
      let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(unwrappedCurrentLocation.coordinate.latitude, unwrappedCurrentLocation.coordinate.longitude)
      let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
   }
   
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error)
   }
   
   
}
