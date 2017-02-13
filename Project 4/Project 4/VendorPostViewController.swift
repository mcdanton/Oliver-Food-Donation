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

class VendorPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
   // MARK: Properties
   
   let imagePicker = UIImagePickerController()
   var imageToPost: UIImage?
   var imageDownloadURL = ""
   
   
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
      } else {
         let alertController = UIAlertController(title: "No Camera", message: "Unable to access the camera", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(action)
         self.present(alertController, animated: true, completion: nil)
      }
   }
   
   
   
   @IBAction func postButtonPressed(_ sender: Any) {
      
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
            
            FirebaseModel.sharedInstance.postFood(title: unwrappedSelf.postTitle.text!, additionalInfo: unwrappedSelf.postDescription.text!, quantity: unwrappedSelf.quantity.text!, deadline: unwrappedSelf.deadline.text!, date: Date(), imageURL: downloadURL!, complete: { foodPostingUID in
               print("----------- LOOKING GOOD!! ---------------")

               
               FirebaseModel.sharedInstance.addVendorLocation(foodPostingUID: foodPostingUID)
               print("----------- THANKS YOU TOO!! ---------------")

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
            
            FirebaseModel.sharedInstance.postFood(title: unwrappedSelf.postTitle.text!, additionalInfo: unwrappedSelf.postDescription.text!, quantity: unwrappedSelf.quantity.text!, deadline: unwrappedSelf.deadline.text!, date: Date(), imageURL: downloadURL!, complete: { foodPostingUID in
               
               print("----------- I WORKED!! ---------------")
               FirebaseModel.sharedInstance.addVendorLocation(foodPostingUID: foodPostingUID)
               print("----------- SO DID I !! ---------------")
               
               self?.performSegue(withIdentifier: "VendorPostVCToVendorPostSuccessfulVC", sender: self)

            })
         })
      }
   }
   
   
   // MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      imagePicker.delegate = self
      sendMessage()
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
   
   
   // MARK: Push Notifications
   
   func sendMessage() {
      
      let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.allHTTPHeaderFields = [
         "Content-Type":"application/json",
         "Authorization":"key=ctuF4e66Hfs:APA91bFjOHHWGjfX44SpjkQo51o0Z_rJoBPziygjvzC8FiQjUFYkkf51moHiLvEf3VTt_-g3tZ9Uprs--LeWnOS7RuJcqVeUmjk7UaGrvY3FQ3Xa3IzuYTqj9T3fq90oQdZ3nsVqQ8ZI"
      ]
      let body: [String: Any] = [
         "to": "/topics/app",
         "notification" : [
            "body": "You da man",
            "title": "To Dan"
         ]
      ]
      let data = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
      request.httpBody = data
      
      URLSession.shared.dataTask(with: request) { data, response, error in
         
         if let data = data {
            
            let resp = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(resp)
            
         }
         }.resume()
   }
   
   
}
