//
//  VendorPostViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/2/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import CoreLocation

class VendorPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
   // MARK: Properties
   
   let imagePicker = UIImagePickerController()
   var imageHasBeenSet: Bool = false
   
   
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
      }
   }
   
   @IBAction func takePhotoSelected(_ sender: Any) {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
         
         imagePicker.sourceType = UIImagePickerControllerSourceType.camera
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
      }
   }
   
   
   @IBAction func postButtonPressed(_ sender: Any) {
      
      
      FirebaseModel.sharedInstance.postFood(title: self.postTitle.text!, additionalInfo: self.postDescription.text!, quantity: self.quantity.text!, deadline: self.deadline.text!, date: Date(), complete: { foodPostingUID in
         
         FirebaseModel.sharedInstance.addVendorLocation(foodPostingUID: foodPostingUID, title: self.postTitle.text!, additionalInfo: self.postDescription.text!, quantity: self.quantity.text!, deadline: self.deadline.text!, date: Date())
         
      })
      
      self.view.alpha = 0
   }
   
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      imagePicker.delegate = self
   }
   
   
   // MARK: Saving Image To Camera
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
         if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImageView.image = image
            imageHasBeenSet = true
         }
      } else {
         print("THERE WAS A PROBLEM WITH THE IMAGE SELECTED")
      }
      self.dismiss(animated: true, completion: nil)
   }
   
   
   
}
