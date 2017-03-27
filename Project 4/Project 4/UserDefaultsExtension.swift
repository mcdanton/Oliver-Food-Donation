//
//  UserDefaultsExtension.swift
//  Project 4
//
//  Created by Dan Hefter on 3/24/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation

// Extension used to store user roles so user who has previously signed in can be directed past the login process to the appropriate area
extension UserDefaults {
   
   enum UserDefaultsKeys: String {
      case userRole
   }
   
   func setIsLoggedIn(value: String) {
      set(value, forKey: UserDefaultsKeys.userRole.rawValue)
      synchronize()
   }
   
   func isLoggedIn() -> Bool {
      return bool(forKey: UserDefaultsKeys.userRole.rawValue)
   }
   
}
