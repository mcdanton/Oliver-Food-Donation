//
//  ConsumerRequestSuccessfulViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/9/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit

class ConsumerRequestSuccessfulViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      dismissViewController()
   }


   
   // Used to bring Consumer back to home page after successful food request
   func dismissViewController() {
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
         self?.performSegue(withIdentifier: "ConsumerRequestSuccessfulVCToConsumerHomeVC", sender: self)
      })
   }

}
