//
//  icon.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/17/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class Icons: PFObject, PFSubclassing {
    @NSManaged var icon:PFFile?
    @NSManaged var name:String?
    
    // 3
    static func parseClassName() -> String {
        return "Icons"
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
