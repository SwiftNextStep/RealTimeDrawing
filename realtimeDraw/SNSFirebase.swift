//
//  SNSFirebase.swift
//  realtimeDraw
//
//  Created by Icaro Barreira Lavrador on 26/10/15.
//  Copyright © 2015 Swift Next Step. All rights reserved.
//

import UIKit

class SNSFirebase {
    let callbackFromFirebase = "callbackFromFirebase"
    static let sharedInstance = SNSFirebase()
    var chieldAddedHandler = FirebaseHandle()
    
    private init(){
        chieldAddedHandler = firebase.observeEventType(.ChildAdded, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(self.callbackFromFirebase, object: nil, userInfo: ["send":snapshot])
        })
    }

    let pathsInLine = NSMutableSet()
    let firebase = Firebase(url:"https://sns-drawningapp.firebaseio.com/")

    func testUnit(text:String){
        firebase.childByAppendingPath(text).removeValue()
    }
    
    func addPathToSend(path: SNSPath)->String{
        let firebaseKey = firebase.childByAutoId()
        pathsInLine.addObject(firebaseKey)
        firebaseKey.setValue(path.serialize()) { (error:NSError!, ref:Firebase!) -> Void in
            if let error = error{
                print("Error saving path to firebase \(error.localizedDescription)")
            } else{
                self.pathsInLine.removeObject(firebaseKey)
            }
        }
        return firebaseKey.key
    }

}
