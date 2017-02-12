//
//  Enums.swift
//  Project 4
//
//  Created by Dan Hefter on 2/8/17.
//  Copyright © 2017 GA. All rights reserved.
//

import Foundation

// Assigning a status to a food that was posted
enum PostStatus: String {
   
   case open = "Open"
   case pending = "Pending"
   case closed = "Closed"
}

// Assigning a Role to a new user
enum UserRole: String {
   
   case vendor = "Vendor"
   case consumer = "Consumer"
}


// For Requested Food
enum StatusOfPickup: String {
   
   case pending = "Pending Pick Up"
   case pickedUp = "Picked Up"
   case canceled = "Canceled"
   case closed = "Closed"
}

enum StatusOfRequest: String {
   
   case pending = "Pending"
   case approved = "Approved"
   case rejected = "Rejected"
   case canceled = "Canceled"
}
