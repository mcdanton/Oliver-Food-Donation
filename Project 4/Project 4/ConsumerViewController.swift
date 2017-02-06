//
//  ConsumerViewController.swift
//  Project 4
//
//  Created by Dan Hefter on 2/6/17.
//  Copyright © 2017 GA. All rights reserved.
//

import UIKit
import CoreLocation

class ConsumerViewController: UIViewController {
   
   
   @IBOutlet weak var myLabel: UILabel!
   
   var myLocation = CLLocation(latitude: 37.785834, longitude: -122.406417)

    override func viewDidLoad() {
        super.viewDidLoad()
      
      FirebaseModel.sharedInstance.queryLocation()
      print("MY LOCATOIN IS : \(myLocation)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
