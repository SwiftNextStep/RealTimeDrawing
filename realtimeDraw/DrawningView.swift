//
//  drawningView.swift
//  realtimeDraw
//
//  Created by Icaro Barreira Lavrador on 26/10/15.
//  Copyright © 2015 Swift Next Step. All rights reserved.
//

import UIKit

class DrawningView: UIView {
    
    var currentTouch:UITouch?
    var currentPath: Array<CGPoint>?
    var currentSNSPath: SNSPath?
    var allPaths = Array<SNSPath>()
    var allKeys = Array<String>()
    var currentColor:UIColor?
    let firebase = SNSFirebase.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addFromFirebase:"), name: firebase.callbackFromFirebase, object: nil)

    }
    
    func addFromFirebase(sender: NSNotification){
        if let info = sender.userInfo as? Dictionary<String,FDataSnapshot> {
            let data = info["send"]
            if let firebaseKey = data?.key{
                if !allKeys.contains(firebaseKey){
                    if let data = data?.value{
                        print(data)
                        let points = data.valueForKey("points") as! NSArray
                        let firstPoint = points.firstObject!
                        let currentPoint = CGPoint(x: firstPoint.valueForKey("x") as! Double, y: firstPoint.valueForKey("y") as! Double)
                        currentSNSPath = SNSPath(point: currentPoint, color: UIColor.blackColor())
                        for point in points{
                            let p = CGPoint(x: point.valueForKey("x") as! Double, y: point.valueForKey("y") as! Double)
                            currentSNSPath?.addPoint(p)
                        }
                    }
                    resetPatch()
                    setNeedsDisplay()
                }
            }
        }
    }
    
    //MARK: Drawning functions
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.5)
        CGContextBeginPath(context)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)

        for path in allPaths{
            let pathArray = path.points
            if let firstPoint = pathArray.first{
                CGContextMoveToPoint(context, firstPoint.x!, firstPoint.y!)
                if (pathArray.count > 1){
                    for index in 1...pathArray.count - 1{
                        let currentPoint = pathArray[index]
                        CGContextAddLineToPoint(context, currentPoint.x!, currentPoint.y!)
                    }
                }
                CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            }
        }
        
    
        if let firstPoint = currentPath?.first{
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y)
            if (currentPath!.count > 1){
                for index in 1...currentPath!.count - 1{
                    let currentPoint = currentPath![index]
                    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
                }
            }
            CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        }
    }
    
    
    //MARK: Touch functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentColor = UIColor.blackColor() //FIXME:
        if (currentPath == nil){
            currentTouch = UITouch()
            currentTouch = touches.first
            let currentPoint = currentTouch?.locationInView(self)
            if let currentPoint = currentPoint{
                currentPath = Array<CGPoint>()
                currentPath?.append(currentPoint)
                if let currentColor = currentColor{
                    currentSNSPath = SNSPath(point: currentPoint, color: currentColor)
                } else{
                    currentSNSPath = SNSPath(point: currentPoint, color: UIColor.blackColor())
                }
            } else{
                print("Find an empty touch")
            }
        }
        setNeedsDisplay()
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        addTouch(touches)
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        addTouch(touches)
        resetPatch()
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        resetPatch()
        print("Touch Cancelled")
        setNeedsDisplay()
        super.touchesCancelled(touches, withEvent: event)
    }
    
    func resetPatch(){
        currentTouch = nil
        currentPath = nil
        currentSNSPath?.serialize()
        if let pathToSend = currentSNSPath{
            let returnKey = firebase.addPathToSend(pathToSend)
            allKeys.append(returnKey)
            allPaths.append(pathToSend)
        }
    }
    
    func addTouch(touches: Set<UITouch>){
        if (currentPath != nil){
            for touch in touches{
                if (currentTouch == touch){
                    let currentPoint = currentTouch?.locationInView(self)
                    if let currentPoint = currentPoint{
                        currentPath?.append(currentPoint)
                        currentSNSPath?.addPoint(currentPoint)
                    } else{
                        print("Find an empty touch")
                    }
                }
            }
        }
        setNeedsDisplay()
    }
}
