//
//  ButtonExtension.swift
//  Project 4
//
//  Created by Dan Hefter on 2/7/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import UIKit

// Class that extends button to add our default button color and shadow settings
@IBDesignable class MyButton: UIButton {
   

   override func draw(_ rect: CGRect) {
      super.draw(rect)
      self.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
      self.layer.shadowOffset = CGSize(width: 4, height: 4)
      self.layer.shadowOpacity = 4
      self.layer.shadowRadius = 4
      self.layer.masksToBounds = false
      self.layer.cornerRadius = 10
      self.layer.backgroundColor = UIColor(red: 239/255, green: 211/255, blue: 20/255, alpha: 1.0).cgColor


   }
   
 
   

 
   
   
}
