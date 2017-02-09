//
//  ConsumerFoodPostDetailVendorInfoTableViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class ConsumerFoodPostDetailVendorInfoTableViewCell: UITableViewCell {
   
   
   // MARK: Properties
   
   
   
   // MARK: Outlets
   
   @IBOutlet weak var vendorName: UILabel!
   @IBOutlet weak var vendorAddress: UILabel!
   
   
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
