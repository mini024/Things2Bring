//
//  Event.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/13/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Realm
import RealmSwift

class Event: PFObject, PFSubclassing {
    @NSManaged var Title: String
    @NSManaged var Date: NSDate?
    @NSManaged var Icon: PFFile?
    @NSManaged var eventDescription: String
    @NSManaged var Address: String?
    @NSManaged var User: PFUser?
    var rsvp:Int?
    
    // 3
    static func parseClassName() -> String {
        return "Event"
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
    
    
    func print() {
        println(Title)
        println(Date)
        println(Address)
        println(eventDescription)
    }
    
    func edited(event2: Event) -> Bool{
        if Title != event2.Title || Address != event2.Address || Date != event2.Date || eventDescription != event2.eventDescription || Icon != event2.Icon{
            return true
        } else{
            return false
        }
    }

}

class Events: Object {
    dynamic var Title: String?
    dynamic var Date: NSDate?
    //dynamic var Icon: PFFile?
    dynamic var eventDescription: String?
    dynamic var Address: String?
    //dynamic var User: PFUser?
}






