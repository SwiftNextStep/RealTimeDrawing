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
    var colorPickerView = NKOColorPickerView()
    var currentColor = String()
    
    @IBOutlet weak var drawingView: DrawningView!
    
    @IBAction func clear(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(firebase.callbackResetDrawing, object: nil)        
    }
    
    @IBOutlet weak var colorButtonOutlet: UIButton!
    @IBAction func colorButtonAction(sender: AnyObject) {
        if colorButtonOutlet.titleLabel?.text == "Change Color"{
            let frame = drawingView.frame
            colorPickerView = NKOColorPickerView(frame: frame, color: UIColor.whiteColor()) { (color:UIColor!) -> Void in
                let cgColor = color.CGColor
                self.currentColor = CIColor(CGColor: cgColor).stringRepresentation
            }
            view.addSubview(colorPickerView)
            colorButtonOutlet.setTitle("Dismiss Color Picker", forState: .Normal)
        } else{
            colorPickerView.removeFromSuperview()
            colorButtonOutlet.setTitle("Change Color", forState: .Normal)
            NSNotificationCenter.defaultCenter().postNotificationName(firebase.callbackNewColor, object: nil, userInfo: ["newColor":self.currentColor])
            print(self.currentColor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

