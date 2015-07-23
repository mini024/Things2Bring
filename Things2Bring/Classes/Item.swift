//
//  Item.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/17/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class Items: PFObject, PFSubclassing {
    @NSManaged var name:String?
    @NSManaged var eventId:String?
    var total:Float?
    var subtotal:Float?
    var recolected:Int?
    @NSManaged var userId: PFUser?
    
    
    static func parseClassName() -> String {
        return "Items"
    }
    
    // 4
    override init () {
        super.init()
        
        
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            
        }
    }

}
