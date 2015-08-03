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

class ParseHelper {
    
    static var guests: [Guest]?
    static var events: [Events]?
    
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
    static func loadItem(event: Event, completionBlock: PFArrayResultBlock){
        var queryItems = Items.query()
        queryItems?.whereKey("event", equalTo: event)
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
        query?.whereKey("event", equalTo: event)
        query!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            items = result as? [Items] ?? []
            if items!.count > 0{
                for index in 0...items!.count - 1 {
                    items![index].deleteInBackground()
                }
            }
        }
        
        var guestss:[Guest]?
        var queryg = Guest.query()
        queryg?.whereKey("event", equalTo: event)
        queryg!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            guestss = result as? [Guest] ?? []
            if guestss!.count > 0{
                for index in 0...guestss!.count - 1 {
                    guestss![index].deleteInBackground()
                }
            }
        }
        
        event.deleteInBackground()

    }
    
//    //MARK: Parse Loading Guests
//    static func LoadingGuests(event: Event){
//        var guestquery = Guest.query()
//        guestquery?.whereKey("Event", equalTo: event.objectId!)
//        guestquery?.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
//            let guests = result as? [Guest] ?? []
//            
//        }
//    }
    
    //MARK: Finding certain guest
    static func findingguest(theevent: Event) -> String{
        if let guests = guests{
            for i in 0...guests.count - 1 {
                if guests[i].event!.objectId! == theevent.objectId! && guests[i].userId! == PFUser.currentUser()!{
                    return guests[i].objectId!
                }
            }
        } else {
            return "No Guest"
        }
        return "No Guest"
    }
    
    //MARK: Parse Checking if guest exists
    static func RSVP(event: Event, guest: Guest){
        var response = findingguest(event)
        if response == "No Guest"{
            guest.saveInBackground()
        } else {
            self.UpdateGuest(response, theguest: guest)
        }
    }
    
    //MARK: Update guest 
    static func UpdateGuest(guestId: String, theguest: Guest){
        var user = PFUser.currentUser()
        var query = Guest.query()
        query!.getObjectInBackgroundWithId(guestId) {
            (guest: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else{
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
    
    //MARK: Adding what you are bringing
    static func Bringing(event: Event , taking: [Items]){
        var guestId = findingguest(event)
        var user = PFUser.currentUser()
        var query = Guest.query()
        if guestId != "No Guest" {
            query!.getObjectInBackgroundWithId(guestId) {
                (guest: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                } else{
                    var itemsTaking: [Items]
                    if let bring = guest!.objectForKey("items") as? [Items]{
                        var birnging = guest!.objectForKey("items") as! [Items]
                        itemsTaking = taking + birnging
                        guest?.setObject(itemsTaking, forKey: "items")
                        guest!.saveInBackground()
                    }
                }
            }
        } else {
            var guest = Guest()
            guest.event = event
            guest.userId = PFUser.currentUser()
            guest.items = taking
            guest.rsvp = 0
            guest.saveInBackground()
        }
    }
    
    static func ItemDetail(event: Event, item: Items, completionBlock: PFArrayResultBlock){
        var users:[Guest] = []
        var guestquery = Guest.query()
        guestquery?.whereKey("event", equalTo:event)
        guestquery?.whereKey("items", containedIn: [item])
        guestquery?.includeKey("items")
        guestquery?.includeKey("userId")
        guestquery?.findObjectsInBackgroundWithBlock(completionBlock)
    }
}
