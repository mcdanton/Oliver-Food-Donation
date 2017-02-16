//
//  ConsumerFoodPostDetailGeneralFoodInfoTableViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class ConsumerFoodPostDetailGeneralFoodInfoTableViewCell: UITableViewCell {
   
   
   // MARK: Properties
   var postImageURL: String? {
      didSet {
         foodImage.setImageWithURL(urlString: postImageURL)
      }
   }
   
   
   // MARK: Outlets
   
   @IBOutlet weak var foodImage: UIImageView!
   @IBOutlet weak var foodTitle: UILabel!
   @IBOutlet weak var foodAmount: UILabel!
   @IBOutlet weak var availableUntil: UILabel!
   @IBOutlet weak var foodDistance: UILabel!

   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
