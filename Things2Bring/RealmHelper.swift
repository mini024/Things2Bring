//
//  Helper.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/27/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import Parse

class RealmHelper {
    
    //MARK: Get rsvp
    static func getrsvp(event: Event) -> Int{
        let realm = Realm()
        var rsvp = -1
        var guestevents = realm.objects(Guests)
        println(guestevents)
        if guestevents.count != 0{
        for index in 0...guestevents.count - 1{
            var guest = guestevents[index] as Guests
            if guest.eventid == event.objectId{
                return guest.rsvp
            }
        }
        }
        return rsvp
    }
    
    static func modifyrsvp(event: Event, realm: Realm){
        
    }
}