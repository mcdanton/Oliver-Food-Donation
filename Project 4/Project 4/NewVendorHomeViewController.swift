//
//  NewVendorHomeViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/12/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase

class NewVendorHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
   
   // MARK: Properties
   
   var allPosts = [Post]() {
      didSet {
         collectionViewOutlet.reloadData()
      }
   }
   
   
   //MARK: Outlets
   
   
   @IBOutlet weak var collectionViewOutlet: UICollectionView!
   
   
   
   
   
   //MARK: View Loading
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      FirebaseModel.sharedInstance.queryVendorPosts(searchPath: "foodPosted", key: "vendor", valueToSearch: (FIRAuth.auth()?.currentUser?.uid)!, success: { [weak self] arrayOfPosts in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.allPosts = arrayOfPosts
      })
   }
   
   @IBAction func VendorPostSuccessfulVCToVendorHomeVC(_ sender: UIStoryboardSegue) {
   }
   
   // MARK: Collection View Protocol Functions
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return allPosts.count

   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewVendorHomeCollectionViewCell", for: indexPath) as! NewVendorHomeCollectionViewCell
      
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOffset = CGSize(width: 5, height: 5)
      cell.layer.shadowOpacity = 1
      cell.layer.shadowRadius = 5
      cell.layer.masksToBounds = false
      cell.layer.cornerRadius = 10

      
      cell.postTitle.text = allPosts[indexPath.row].title
      cell.postStatus.text = allPosts[indexPath.row].status.rawValue
      cell.postDate.text = allPosts[indexPath.row].date.prettyLocaleFormatted
      cell.postImageURL = allPosts[indexPath.row].imageURL
      
      return cell
   }
   
   
   
}
