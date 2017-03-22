//
//  ConsumerFoodPostDetailMessageToVendorTableViewCell.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit


class ConsumerFoodPostDetailMessageToVendorTableViewCell: UITableViewCell, UITextViewDelegate {

   // MARK: Properties
   var messageToVendor: String?
   
   
   // MARK: Outlets
   @IBOutlet weak var messageToVendorTV: UITextView!

   

   // MARK: View Loading Functions
    override func awakeFromNib() {
        super.awakeFromNib()
      
      messageToVendorTV.delegate = self
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   
   
   // MARK: Text View Editing Functions
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
      let numberOfChars = newText.characters.count // for Swift use count(newText)
      return numberOfChars < 80;
   }
   
   
   
   func textViewDidChange(_ textView: UITextView) {
      messageToVendor = textView.text
   }
   
   
   


}
