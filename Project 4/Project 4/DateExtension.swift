//
//  File.swift
//  Project 4
//
//  Created by Dan Hefter on 2/2/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation

extension Date {
   
   var prettyLocaleFormatted : String {
      return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
   }
   
   var prettyLocaleFormattedWithTime : String {
      return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .short)
   }
   
}

