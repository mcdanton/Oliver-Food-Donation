//
//  DismissKeyboardExtension.swift
//  Project 4
//
//  Created by Dan Hefter on 2/12/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
   
   func hideKeyboardWhenTappedAround() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      view.addGestureRecognizer(tap)
   }
   
   func dismissKeyboard() {
      view.endEditing(true)
   }
}
