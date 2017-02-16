//
//  ConsumerRequestsViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/13/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ConsumerRequestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
   
   // MARK: Properties
   
   var allRequests = [Request]() {
      didSet {
         collectionViewOutlet.reloadData()
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var collectionViewOutlet: UICollectionView!
   
   
   // MARK: View Loading
   
   
   override func viewWillAppear(_ animated: Bool) {
      
      FirebaseModel.sharedInstance.queryRequests(searchPath: "requests", key: "requestedBy", valueToSearch: (FIRAuth.auth()?.currentUser?.email)!, success: { [weak self] arrayOfRequests in
         guard let unwrappedSelf = self else { return }
         unwrappedSelf.allRequests = arrayOfRequests
      })
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }

   
   
   // MARK: Collection View Setup
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if allRequests.isEmpty {
         return 1
      } else {
         return allRequests.count
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsumerRequestsCollectionViewCell", for: indexPath) as! ConsumerRequestsCollectionViewCell
      if allRequests.isEmpty {
         cell.noOpenRequestsView.alpha = 1.0
      } else {
         cell.noOpenRequestsView.alpha = 0.0
         

         cell.foodTitle.text = allRequests[indexPath.row].foodRequested
         cell.requestMessage.text = allRequests[indexPath.row].requestMessage
         cell.requestDate.text = allRequests[indexPath.row].requestDate.prettyLocaleFormatted
         cell.pickupStatus.text = allRequests[indexPath.row].pickupStatus.rawValue
         cell.requestStatus.text = allRequests[indexPath.row].requestStatus.rawValue

      }
      return cell
   }
   
   
}
