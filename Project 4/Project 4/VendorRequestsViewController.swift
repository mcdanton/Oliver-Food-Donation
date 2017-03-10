//
//  VendorRequestsViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/10/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class VendorRequestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
   
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
      
      FirebaseModel.sharedInstance.queryRequests(searchPath: "requests", key: "itemVendor", valueToSearch: (FIRAuth.auth()?.currentUser?.uid)!, success: { [weak self] arrayOfRequests in
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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorRequestsCollectionViewCell", for: indexPath) as! VendorRequestsCollectionViewCell
      if allRequests.isEmpty {
         cell.noOpenRequestsView.alpha = 1.0
      } else {
         cell.noOpenRequestsView.alpha = 0.0
         
         switch allRequests[indexPath.row].requestStatus {
         case .pending:
            cell.actionView.alpha = 1.0
         default:
            cell.actionView.alpha = 0.0
            cell.requestStatus.text = allRequests[indexPath.row].requestStatus.rawValue
         }
         cell.currentRequest = allRequests[indexPath.row]
         cell.requester.text = allRequests[indexPath.row].requester
         cell.foodTitle.text = allRequests[indexPath.row].foodRequested
         cell.requestMessage.text = allRequests[indexPath.row].requestMessage
         cell.requestDate.text = allRequests[indexPath.row].requestDate.prettyLocaleFormatted
         cell.pickupStatus.text = allRequests[indexPath.row].pickupStatus.rawValue
      }
      return cell
   }
   
   
   // This ensures the cell never extends past its SuperView on smaller screens
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      return CGSize(width: collectionView.bounds.size.width - 32, height: 263)
   }
   
   
   
}



