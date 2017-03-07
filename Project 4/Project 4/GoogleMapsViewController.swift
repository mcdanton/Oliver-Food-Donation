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
   
   // Determining Location Authorization Status
   var locationAccessNotYetAsked : Bool {
      return CLLocationManager.authorizationStatus() == .notDetermined
   }
   
   var locationAccessGranted : Bool {
      return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
   }
   
   
   
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
      
      
      if self.locationAccessGranted {
         
         INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 10, block: { [weak self] (location:CLLocation?, accuracy:INTULocationAccuracy, status:INTULocationStatus) in
            guard let unwrappedSelf = self else { return }
            
            
            switch status {
            case .success:
               unwrappedSelf.initGoogleMaps(userCoordinates: location!)
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
      }
   }
   
   
   // MARK: Initialize Google Maps
   
   func initGoogleMaps(userCoordinates: CLLocation) {
      
      let userLongitude = userCoordinates.coordinate.longitude
      let userLatitude = userCoordinates.coordinate.latitude
      
      let camera = GMSCameraPosition.camera(withLatitude: userLatitude, longitude: userLongitude, zoom: 6.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      mapView.isMyLocationEnabled = true
      self.googleMapsView.camera = camera
      
      self.googleMapsView.delegate = self
      self.googleMapsView.isMyLocationEnabled = true
      self.googleMapsView.settings.myLocationButton = true
      
      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
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
