//
//  ParseHelper.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/21/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ParseHelper{
    //MARK: Parse Getting Host Events
    static func loadEvents(completionBlock: PFArrayResultBlock){
        var queryEventsHost = Event.query()
        queryEventsHost!.whereKey("User", equalTo: PFUser.currentUser()!)
        queryEventsHost!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Parse Getting Guest Events
    static func loadGuestEvents(completionBlock: PFArrayResultBlock){
        var queryEventsGuest = Guest.query()
        queryEventsGuest!.whereKey("userId", equalTo: PFUser.currentUser()!)
        queryEventsGuest!.includeKey("event")
        queryEventsGuest!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Parse Getting Event from eventId
    static func loadEvent(eventId:String, completionBlock: PFArrayResultBlock){
        var queryEvent = Event.query()
        queryEvent!.whereKey("objectId", equalTo: eventId)
        queryEvent!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: Parse load Items
    static func loadItem(eventId: String, completionBlock: PFArrayResultBlock){
        var queryItems = Items.query()
        queryItems?.whereKey("EventId", equalTo: eventId)
        queryItems?.findObjectsInBackgroundWithBlock(completionBlock)

    }
    //MARK: Parse Save Events
    static func saveEvent(user: PFUser, event: Event){
        
    }
    
    //MARK: Parse Save Items
    static func saveItem(user: PFUser, event: Event, item: Items){
        
    }
    
    //MARK: Delete Event && Items of Event
    static func DeleteEvent(event: Event){
        var items:[Items]?
        var query = Items.query()
        query?.whereKey("EventId", equalTo: event.objectId!)
        query!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            items = result as? [Items] ?? []
            if items!.count > 0{
                for index in 0...items!.count - 1 {
                    items![index].deleteInBackground()
                }
            }
        }
        
        event.deleteInBackground()

    }
    
    //MARK: Parse Loading Guests
    static func LoadingGuests(event: Event){
        var guestquery = Guest.query()
        guestquery?.whereKey("Event", equalTo: event.objectId!)
        guestquery?.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            let guests = result as? [Guest] ?? []
            
        }
    }
    
    //MARK: Parse Checking if guest exists
    static func RSVP(event: Event, guest: Guest){
        var guestquery = Guest.query()
        guestquery?.whereKey("userId", equalTo: PFUser.currentUser()!)
        guestquery?.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            let guests = result as? [Guest] ?? []
            if guests.count != 0{
            for index in 0...guests.count - 1 {
                var eventt = guests[index].event
                if eventt == event{
                    self.UpdateGuest(guests[index].objectId!, theguest: guest)
                } else {
                   guest.saveInBackground()
                }
            }
            } else {
                guest.saveInBackground()
            }
        }
    }
    
    //MARK: Update guest 
    static func UpdateGuest(guestId: String, theguest: Guest){
        println(theguest)
        var user = PFUser.currentUser()
        var query = Guest.query()
        query!.getObjectInBackgroundWithId(guestId) {
            (guest: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else{
                println("saved")
                guest?.setObject(theguest.rsvp, forKey: "rsvp")
                guest!.saveInBackground()
            }
        }
    }
    
    //MARK: Getting Friends Going
    static func friendsgoing(event: Event, rsvp: Int) -> [PFUser]{
        var users:[PFUser] = []
        var guestquery = Guest.query()
        guestquery?.whereKey("event", equalTo: event)
        guestquery?.includeKey("userId")
        guestquery?.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            let guests = result as? [Guest] ?? []
            println("Friends going")
            if guests.count != 0{
                for index in 0...guests.count - 1 {
                    var eventt = guests[index].event
                    if guests[index].rsvp == rsvp{
                        users.append(guests[index].userId!)
                    }
                }
            }
        }
        return users
    }
}
