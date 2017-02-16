//
//  ConsumerHomeTableViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class ConsumerHomeTableViewCell: UITableViewCell {
   
   // MARK: Properties
   
   var postImageURL: String? {
      didSet {
         foodPostImage.setImageWithURL(urlString: postImageURL)
      }
   }

   // MARK: Outlets
   
   @IBOutlet weak var foodPostTitle: UILabel!
   @IBOutlet weak var foodPostDistance: UILabel!
   @IBOutlet weak var foodPostStatus: UILabel!
   @IBOutlet weak var foodPostImage: UIImageView!
   
   
   
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
