//
//  ViewController.swift
//  GarmanApps
//
//  Created by Ben Garman on 17/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import CloudKit

class ViewControllerSettings: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var notificationButtonImage: UIImageView!
    @IBOutlet weak var timeBeforImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func notificationCicked(_ sender: Any) {
        if notificationButtonImage.image == UIImage(named: "onPressed"){
            notificationButtonImage.image = UIImage(named: "offPressed")
            
        }else{
            notificationButtonImage.image = UIImage(named: "onPressed")
        }
    }
    @IBAction func MinClicked(_ sender: Any) {
        timeBeforImage.image = UIImage(named: "5TimeSelector")
    }
    
    @IBAction func tenMinClicked(_ sender: Any) {
        timeBeforImage.image = UIImage(named: "10TimeSelector")

    }
    
    @IBAction func fiveteenMinClicked(_ sender: Any) {
        timeBeforImage.image = UIImage(named: "15TimeSelector")

    }
    
}
