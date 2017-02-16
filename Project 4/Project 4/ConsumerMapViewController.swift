//
//  VendorMapViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/3/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConsumerMapViewController: UIViewController, CLLocationManagerDelegate {
   
   
   
   // MARK: Properties
   let locationManager = CLLocationManager()
   
   
   
   
   
   // MARK: Outlets
   
   @IBOutlet weak var mapView: MKMapView!
   
   
   
   
   
   

    override func viewDidLoad() {
        super.viewDidLoad()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


   
   // MARK: Location Functions
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location = locations[0]
      
      let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
      let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
      mapView.setRegion(region, animated: true)
      
      self.mapView.showsUserLocation = true
      
   }

}
