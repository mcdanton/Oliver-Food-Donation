//
//  ConsumerProfileViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 3/16/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ConsumerProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
   
   
   // MARK: Properties
   
   var activeField: UITextField?
   let imagePicker = UIImagePickerController()
   var postImageURL: String? {
      didSet {
         consumerImageView.setImageWithURL(urlString: postImageURL)
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var consumerImageView: UIImageView!
   @IBOutlet weak var consumerNameTF: UITextField!
   @IBOutlet weak var consumerEmailTF: UITextField!
   @IBOutlet weak var consumerAddressTF: UITextField!
   @IBOutlet weak var scrollView: UIScrollView!
   
   
   // MARK: Actions
   
   @IBAction func selectImagePressed(_ sender: Any) {
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
   
   
   
   // MARK: View Loading Functions
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      consumerNameTF.delegate = self
      consumerEmailTF.delegate = self
      consumerAddressTF.delegate = self
      imagePicker.delegate = self
      
      registerForKeyboardNotifications()
      hideKeyboardWhenTappedAround()
      
      FirebaseModel.sharedInstance.observeConsumer(consumerToObserve: (FIRAuth.auth()?.currentUser?.uid)!, success: { [weak self] consumer in
         guard let unwrappedSelf = self else { return }
         if let consumer = consumer {
            
            unwrappedSelf.consumerNameTF.text = consumer.name
            unwrappedSelf.consumerEmailTF.text = FIRAuth.auth()?.currentUser?.email
            unwrappedSelf.consumerAddressTF.text = consumer.location
            
            if let consumerLogo = consumer.logoURL {
               unwrappedSelf.postImageURL = consumerLogo
            }
         }
      })
   }
   
   
   
   // MARK: Saving Image To Camera
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
         if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            consumerImageView.image = image
            
            let imageStorageUID = UUID().uuidString
            
            let uploadData = UIImageJPEGRepresentation(image, 0.1)
            
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child(imageStorageUID)
            
            let _ = imageRef.put(uploadData!, metadata: nil, completion: { (metadata, error) in
               
               let downloadURL = metadata?.downloadURL()?.absoluteString
               
               FirebaseModel.sharedInstance.updateConsumer(child: (FIRAuth.auth()?.currentUser?.uid)!, logoURL: downloadURL!, completion: { [weak self] success in
                  guard let unwrappedSelf = self else { return }
                  
                  unwrappedSelf.dismiss(animated: true, completion: nil)
                  })
            })
         }
         
      } else {
         let alertController = UIAlertController(title: "No Image", message: "There was a problem with the selected image", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
   }
   

   // MARK: Text Field Delegate
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      switch textField {
      case consumerNameTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case consumerEmailTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case consumerAddressTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      default:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      }
   }
   

   // MARK: Adjust View For Keyboard
   
   func registerForKeyboardNotifications() {
      //Adding notifies on keyboard appearing
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func deregisterFromKeyboardNotifications() {
      //Removing notifies on keyboard appearing
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func keyboardWasShown(notification: NSNotification) {
      //Need to calculate keyboard exact size due to Apple suggestions
      self.scrollView.isScrollEnabled = true
      var info = notification.userInfo!
      let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
      let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
      
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      
      var aRect : CGRect = self.view.frame
      aRect.size.height -= keyboardSize!.height
      if let activeField = self.activeField {
         if (!aRect.contains(activeField.frame.origin)){
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
         }
      }
   }
   
   func keyboardWillBeHidden(notification: NSNotification) {
      //Once keyboard disappears, restore original positions
      var info = notification.userInfo!
      let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
      let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      self.view.endEditing(true)
      self.scrollView.isScrollEnabled = false
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      activeField = textField
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      activeField = nil
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      // Try to find next responder
      if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
         nextField.becomeFirstResponder()
      } else {
         // Not found, so remove keyboard.
         textField.resignFirstResponder()
      }
      // Do not add a line break
      return false
   }
   
   
   
   
   
}
