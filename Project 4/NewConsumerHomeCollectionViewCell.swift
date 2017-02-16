//
//  NewConsumerHomeCollectionViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/13/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class NewConsumerHomeCollectionViewCell: UICollectionViewCell {
   
   // MARK: Properties
   
   var postImageURL: String? {
      didSet {
         foodPostImage.setImageWithURL(urlString: postImageURL)
      }
   }
   
   // MARK: Outlets
   
   @IBOutlet weak var foodPostTitle: UILabel!
   @IBOutlet weak var foodPostStatus: UILabel!
   @IBOutlet weak var foodPostImage: UIImageView!
   @IBOutlet weak var foodPostDate: UILabel!
   
 

   
}
