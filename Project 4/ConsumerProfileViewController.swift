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
   @IBOutlet weak var consumerPhoneNumberTF: UITextField!
   @IBOutlet weak var consumerWebsiteTF: UITextField!
   
   
   
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
      consumerPhoneNumberTF.delegate = self
      consumerWebsiteTF.delegate = self
      imagePicker.delegate = self
      
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
      case consumerPhoneNumberTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      case consumerWebsiteTF:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      default:
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= 20 // Bool
      }
   }
   

   
   
   
   
   
   
}
