//
//  Event.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/13/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class Event: PFObject, PFSubclassing {
    var title: String = " "
    var date: NSDate?
    var icon: PFFile?
    var eventDescrption: String = " "
    
    // 3
    static func parseClassName() -> String {
        return "Event"
    }
    
    // 4
    override init () {
        super.init()
        
        
    }

}

class User: PFObject, PFSubclassing {
    var userId: String = " "
    var username: String = " "
    var profilepicture: PFFile?
    var Name: String = " "
    var password: String = " "
    var GuestEventId: String = " "
    
    // 3
    static func parseClassName() -> String {
        return "User"
    }
    
    // 4
    override init () {
        super.init()
        
        
    }
    
}


class Guest: PFObject, PFSubclassing {
    var user: String = " "
    var event: String = " "

    
    // 3
    static func parseClassName() -> String {
        return "Guest"
    }
    
    // 4
    override init () {
        super.init()
        
        
    }
    
}



