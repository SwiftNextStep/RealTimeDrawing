//
//  ViewController.swift
//  realtimeDraw
//
//  Created by Icaro Barreira Lavrador on 26/10/15.
//  Copyright © 2015 Swift Next Step. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let firebase = SNSFirebase.sharedInstance

    @IBOutlet weak var drawingView: DrawningView!
    @IBAction func clear(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(firebase.callbackResetDrawing, object: nil)        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

