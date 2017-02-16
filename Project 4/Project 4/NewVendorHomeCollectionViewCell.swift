//
//  NewVendorHomeCollectionViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/12/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class NewVendorHomeCollectionViewCell: UICollectionViewCell {
   
   // MARK: Properties
   
   var postImageURL: String? {
      didSet {
         postImage.setImageWithURL(urlString: postImageURL)
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var postTitle: UILabel!
   @IBOutlet weak var postDate: UILabel!
   @IBOutlet weak var postStatus: UILabel!
   @IBOutlet weak var postImage: UIImageView!
   

    
}
