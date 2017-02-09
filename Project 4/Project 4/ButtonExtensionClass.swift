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
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOffset = CGSize(width: 5, height: 5)
      self.layer.shadowOpacity = 1
      self.layer.shadowRadius = 5
      self.layer.masksToBounds = false
      self.layer.cornerRadius = 4.0
      self.layer.cornerRadius = 5
      self.backgroundColor = UIColor(red: 235/255, green: 211/255, blue: 74/255, alpha: 1.0)


   }
   
 
   

 
   
   
}
