//
//  SNSPath.swift
//  realtimeDraw
//
//  Created by Icaro Barreira Lavrador on 26/10/15.
//  Copyright © 2015 Swift Next Step. All rights reserved.
//

import UIKit

//MARK: SNSPoint Class
class SNSPoint:NSObject{
    var x:CGFloat?
    var y:CGFloat?
    init(point: CGPoint) {
        x = point.x
        y = point.y
        print("New point created")
    }
}

//MARK: SNSPath Class
class SNSPath: NSObject {
    var points:Array<SNSPoint>
    var color:UIColor

    init(point:CGPoint, color:UIColor) {
        self.color = color
        self.points = Array<SNSPoint>()
        let newPoint = SNSPoint(point: point)
        points.append(newPoint)
        print("Start track points in SNSPath")
        super.init()
    }
    
    func addPoint(point:CGPoint){
        let newPoint = SNSPoint(point: point)
        points.append(newPoint)
        print("New point appended")
    }
    
    func serialize() -> NSDictionary{
        
        let dictionary = NSMutableDictionary()
        dictionary["color"] = 1 //FIXME:
        let pointsOfPath = NSMutableArray()
        for point in points{
            let pointDictionary = NSMutableDictionary()
            pointDictionary["x"] = Int(point.x!)
            pointDictionary["y"] = Int(point.y!)
            pointsOfPath.addObject(pointDictionary)
        }
        dictionary["points"] = pointsOfPath
        print(dictionary)
        return dictionary
    }
    
}
