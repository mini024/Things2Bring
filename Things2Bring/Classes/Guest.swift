//
//  Guest.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/15/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Realm
import RealmSwift

class Guest: PFObject, PFSubclassing {
    @NSManaged var userId:PFUser?
    @NSManaged var event: Event?
    @NSManaged var rsvp: Int
    @NSManaged var item: String
    @NSManaged var rsvp: Int

    
    // 3
    static func parseClassName() -> String {
        return "Guest"
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


class Guests: Object{
    //dynamic var userId:PFUser?
    dynamic var eventid:String?
    dynamic var rsvp: Int = 3
}
