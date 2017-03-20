//
//  VendorProfileViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/12/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class VendorProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
   
   // MARK: Properties
   
   var activeField: UITextField?
   let imagePicker = UIImagePickerController()
   var postImageURL: String? {
      didSet {
         companyImage.setImageWithURL(urlString: postImageURL)
      }
   }
   
   
   // MARK: Outlets
   

   @IBOutlet weak var companyImage: UIImageView!
   @IBOutlet weak var companyNameTF: UITextField!
   @IBOutlet weak var companyEmailTF: UITextField!
   @IBOutlet weak var companyAddressTF: UITextField!
   @IBOutlet weak var companyPhoneNumberTF: UITextField!
   @IBOutlet weak var companyWebsiteTF: UITextField!
   @IBOutlet weak var scrollView: UIScrollView!
   
   
   // MARL: Actions
   
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
   
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      companyNameTF.delegate = self
      companyEmailTF.delegate = self
      companyAddressTF.delegate = self
      companyPhoneNumberTF.delegate = self
      companyWebsiteTF.delegate = self
      imagePicker.delegate = self
      
      registerForKeyboardNotifications()
      hideKeyboardWhenTappedAround()
      
      FirebaseModel.sharedInstance.observeVendor(vendorToObserve: (FIRAuth.auth()?.currentUser?.uid)!, success: { [weak self] vendor in
         guard let unwrappedSelf = self else { return }
         if let vendor = vendor {
            
            unwrappedSelf.companyNameTF.text = vendor.name
            unwrappedSelf.companyEmailTF.text = FIRAuth.auth()?.currentUser?.email
            unwrappedSelf.companyAddressTF.text = vendor.location
            
            if let vendorLogo = vendor.logoURL {
               unwrappedSelf.postImageURL = vendorLogo
            }
         }
      })
   }
   
   
   // MARK: Saving Image To Camera
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
         if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImage.image = image
            
            let imageStorageUID = UUID().uuidString
            
            let uploadData = UIImageJPEGRepresentation(image, 0.1)
            
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child(imageStorageUID)
            
            let _ = imageRef.put(uploadData!, metadata: nil, completion: { (metadata, error) in
               
               let downloadURL = metadata?.downloadURL()?.absoluteString
               
               FirebaseModel.sharedInstance.updateVendor(child: (FIRAuth.auth()?.currentUser?.uid)!, logoURL: downloadURL!, completion: { [weak self] success in
                  guard let unwrappedSelf = self else {return}
                  
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
      case companyNameTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case companyEmailTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case companyAddressTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case companyPhoneNumberTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case companyWebsiteTF:
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
   
   func registerForKeyboardNotifications(){
      //Adding notifies on keyboard appearing
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func deregisterFromKeyboardNotifications(){
      //Removing notifies on keyboard appearing
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
   }
   
   func keyboardWasShown(notification: NSNotification){
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
   
   func keyboardWillBeHidden(notification: NSNotification){
      //Once keyboard disappears, restore original positions
      var info = notification.userInfo!
      let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
      let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
      self.scrollView.contentInset = contentInsets
      self.scrollView.scrollIndicatorInsets = contentInsets
      self.view.endEditing(true)
      self.scrollView.isScrollEnabled = false
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField){
      activeField = textField
   }
   
   func textFieldDidEndEditing(_ textField: UITextField){
      activeField = nil
   }


   
   
   
   
}
