//
//  VendorHomeTableViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 1/31/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class VendorHomeTableViewCell: UITableViewCell {
   
   
   // MARK: Outlets
   

   @IBOutlet weak var postTitle: UILabel!
   @IBOutlet weak var postDate: UILabel!
   @IBOutlet weak var postStatus: UILabel!
   
      

   
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}