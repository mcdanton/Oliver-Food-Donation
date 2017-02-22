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

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
   
   // MARK: Properties

   var locationManager = CLLocationManager()

   
   // MARK: Outlets
   
   @IBOutlet weak var googleMapsView: GMSMapView!

   
   // MARK: Actions
   
   @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
      
      let autoCompleteController = GMSAutocompleteViewController()
      autoCompleteController.delegate = self
      
      self.locationManager.startUpdatingLocation()
      self.present(autoCompleteController, animated: true, completion: nil)
   }
   
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      locationManager = CLLocationManager()
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      locationManager.startMonitoringSignificantLocationChanges()
      
      initGoogleMaps()
   }
   

   // MARK: Initialize Google Maps
   
   func initGoogleMaps() {
      
      let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      mapView.isMyLocationEnabled = true
      self.googleMapsView.camera = camera
      
      self.googleMapsView.delegate = self
      self.googleMapsView.isMyLocationEnabled = true
      self.googleMapsView.settings.myLocationButton = true
      
      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
      marker.title = "Sydney"
      marker.snippet = "Australia"
      marker.map = mapView
   }
   
   
   // MARK: Location Functions
   
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Error while getting location: \(error)")
   }
   
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location = locations.last
      
      let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
      
      self.googleMapsView.animate(to: camera)
      self.locationManager.stopUpdatingLocation()
   }
   
   
   
   // MARK: GMSMapView Delegate
   
   func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      self.googleMapsView.isMyLocationEnabled = true
   }
   
   
   func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      self.googleMapsView.isMyLocationEnabled = true
      if(gesture) {
         mapView.selectedMarker = nil
      }
   }
   
   
   
   // MARK: Google Auto Complete Delegate
   
   func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
      self.googleMapsView.camera = camera
      self.dismiss(animated: true, completion: nil) // dismiss after place is selected
   }
   
   func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      print("Error with AutoComplete: \(error)")
   }

   
   func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      self.dismiss(animated: true, completion: nil) // dismiss if search is cancelled
   }
   
   
   
   
   
}
