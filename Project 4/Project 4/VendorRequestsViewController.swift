//
//  VendorRequestsViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/10/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorRequestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   
   
   // MARK: Collection View Setup

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
   }
   
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorRequestsCollectionViewCell", for: indexPath) as! VendorRequestsCollectionViewCell
      
      
      
      return cell
   }

   
}



