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
   
   
   // MARK: Outlets
   
   @IBOutlet weak var companyName: UILabel!
   @IBOutlet weak var companyEmail: UILabel!
   @IBOutlet weak var companyAddress: UILabel!
   @IBOutlet weak var companyImage: UIImageView!
   
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
   }
   
   
   // MARK: Saving Image To Camera
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
         if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImage.image = image
         }
      } else {
         let alertController = UIAlertController(title: "No Image", message: "There was a problem with the selected image", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
      self.dismiss(animated: true, completion: nil)
   }
   
   
   
   
}
