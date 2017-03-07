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

class VendorProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
   // MARK: Properties
   
   let imagePicker = UIImagePickerController()
   var postImageURL: String? {
      didSet {
         companyImage.setImageWithURL(urlString: postImageURL)
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var companyName: UILabel!
   @IBOutlet weak var companyEmail: UILabel!
   @IBOutlet weak var companyAddress: UILabel!
   @IBOutlet weak var companyImage: UIImageView!
   
   @IBOutlet weak var companyNameTF: UITextField!
   @IBOutlet weak var companyEmailTF: UITextField!
   @IBOutlet weak var companyAddressTF: UITextField!
   @IBOutlet weak var companyPhoneNumberTF: UITextField!
   @IBOutlet weak var companyWebsiteTF: UITextField!
   
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
      hideKeyboardWhenTappedAround()
      imagePicker.delegate = self
      
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
   
   
   
   
}
