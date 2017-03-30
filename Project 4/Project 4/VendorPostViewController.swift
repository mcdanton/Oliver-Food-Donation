//
//  VendorPostViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/2/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseStorage
import GooglePlaces

class VendorPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
   
   // MARK: Properties
   
   let imagePicker = UIImagePickerController()
   var imageToPost: UIImage?
   var imageDownloadURL = ""
   let datePicker = UIDatePicker()
   
   
   // MARK: Outlets
   
   @IBOutlet weak var postTitle: UITextField!
   @IBOutlet weak var quantity: UITextField!
   @IBOutlet weak var deadline: UITextField!
   @IBOutlet weak var postDescription: UITextField!
   @IBOutlet weak var location: UITextField!
   @IBOutlet weak var postImageView: UIImageView!
   
   
   
   // MARK: Actions
   
   @IBAction func imageFromPhoneSelected(_ sender: Any) {
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
         
         imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
      } else {
         let alertController = UIAlertController(title: "No Photos", message: "Unable to access Photo Library", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
   }
   
   @IBAction func takePhotoSelected(_ sender: Any) {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
         
         imagePicker.sourceType = UIImagePickerControllerSourceType.camera
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
      } else {
         let alertController = UIAlertController(title: "No Camera", message: "Unable to access the camera", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
   }
   
   
   
   @IBAction func postButtonPressed(_ sender: Any) {
      
      if (postTitle.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Please enter a Post Title", message: "What do you want the post title to be?", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (quantity.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Please enter a Food Quantity", message: "How much food is available?", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (deadline.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Please enter a Post Deadline", message: "When do you want this post to expire?", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else if (location.text?.isEmpty)! {
         let alertController = UIAlertController(title: "Please enter a Post Location", message: "Where is the food located?", preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(defaultAction)
         self.present(alertController, animated: true, completion: nil)
      } else {
         if let postImage = imageToPost {
            
            let imageStorageUID = UUID().uuidString
            
            let uploadData = UIImageJPEGRepresentation(postImage, 0.1)
            
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child(imageStorageUID)
            
            let _ = imageRef.put(uploadData!, metadata: nil, completion: { [weak self] (metadata, error) in
               guard let unwrappedSelf = self else {return}
               let downloadURL = metadata?.downloadURL()?.absoluteString
               print(downloadURL!)
               unwrappedSelf.imageDownloadURL = downloadURL!
               
               FirebaseModel.sharedInstance.postFood(title: unwrappedSelf.postTitle.text!, additionalInfo: unwrappedSelf.postDescription.text!, quantity: unwrappedSelf.quantity.text!, deadline: unwrappedSelf.datePicker.date, date: Date(), imageURL: downloadURL!, complete: { foodPostingUID in
                  
                  FirebaseModel.sharedInstance.addVendorLocation(foodPostingUID: foodPostingUID)
                  
                  self?.performSegue(withIdentifier: "VendorPostVCToVendorPostSuccessfulVC", sender: self)
               })
            })
            
         } else {
            let postImage = UIImage(named: "Apple")
            let imageStorageUID = UUID().uuidString
            
            let uploadData = UIImageJPEGRepresentation(postImage!, 0.1)
            
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child(imageStorageUID)
            
            let _ = imageRef.put(uploadData!, metadata: nil, completion: { [weak self] (metadata, error) in
               guard let unwrappedSelf = self else {return}
               let downloadURL = metadata?.downloadURL()?.absoluteString
               print(downloadURL!)
               unwrappedSelf.imageDownloadURL = downloadURL!
               
               FirebaseModel.sharedInstance.postFood(title: unwrappedSelf.postTitle.text!, additionalInfo: unwrappedSelf.postDescription.text!, quantity: unwrappedSelf.quantity.text!, deadline: unwrappedSelf.datePicker.date, date: Date(), imageURL: downloadURL!, complete: { foodPostingUID in
                  
                  FirebaseModel.sharedInstance.addVendorLocation(foodPostingUID: foodPostingUID)
                  
                  self?.performSegue(withIdentifier: "VendorPostVCToVendorPostSuccessfulVC", sender: self)
               })
            })
         }
      }
   }
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      postTitle.delegate = self
      quantity.delegate = self
      postDescription.delegate = self
      location.delegate = self
      imagePicker.delegate = self
      hideKeyboardWhenTappedAround()
      createDatePicker()
   }
   
   func dismissViewController() {
      self.performSegue(withIdentifier: "unwindFromAddNewItemVCToVendorHomeVC", sender: self)
   }
   
   // MARK: Saving Image To Camera
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
         if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImageView.image = image
            imageToPost = image
         }
      } else {
         let alertController = UIAlertController(title: "No Image", message: "There was a problem with the selected image", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
      self.dismiss(animated: true, completion: nil)
   }
   
   // MARK: Date Picker
   
   func createDatePicker() {
      
      datePicker.datePickerMode = .dateAndTime
      
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
      toolbar.setItems([doneButton], animated: false)
      
      deadline.inputAccessoryView = toolbar
      deadline.inputView = datePicker
   }
   
   func donePressed() {
      deadline.text = "\(datePicker.date.prettyLocaleFormattedWithTime)"
      self.view.endEditing(true)
   }
   
   
   // MARK: Text Field Delegate
   
   // Launch Google Places AutoPicker when location text field is selected
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      if textField == location {
         launchGoogleAutocomplete()
      }
   }
   
   
   // Limits character input on text fields
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      switch textField {
      case postTitle:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 23 // Bool
      case quantity:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case postDescription:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case location:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      default:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 15 // Bool
      }
   }
   
   
   
   // Present the Google Autocomplete view controller when the button is pressed.
   
   func launchGoogleAutocomplete() {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      present(autocompleteController, animated: true, completion: nil)
   }
   
}


// Google Places Extension

extension VendorPostViewController: GMSAutocompleteViewControllerDelegate {
   
   // Handle the user's selection.
   func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      print("Place name: \(place.name)")
      print("Place address: \(place.formattedAddress)")
      print("Place attributions: \(place.attributions)")
      location.text = place.formattedAddress
      dismiss(animated: true, completion: nil)
   }
   
   func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
   }
   
   // User canceled the operation.
   func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      dismiss(animated: true, completion: nil)
   }
   
   // Turn the network activity indicator on and off again.
   func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
   }
   
   func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
   }
}


