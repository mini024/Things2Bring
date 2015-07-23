//
//  EventViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/14/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class EventViewController: UIViewController {
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var EditSaveButton: UIBarButtonItem!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var friendsGoingButton: UIButton!
    @IBOutlet weak var thingsListButton: UIButton!
    @IBOutlet weak var rsvpSegmentControl: UISegmentedControl!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var event: Event?
    var edit = false
    var host = false
    var eventId = ""
    var openbylink = false
    
    override func viewDidLoad() {
       if openbylink {
            println(eventId)
            ParseHelper.loadEvent(eventId){ (result: [AnyObject]?, error: NSError?) -> Void in
                let events = result as? [Event] ?? []
                self.event = events[0] as Event
                self.displayEvent(self.event!)
                self.checkingifhost()
            }
       } else if let event = event{
            checkingifhost()
        }
    }
    
    func checkingifhost(){
        if PFUser.currentUser() == self.event!.objectForKey("User") as? PFUser{
            rsvpSegmentControl.hidden = true
            displayEvent(self.event!)
        } else {
            rsvpSegmentControl.hidden = false
            EditSaveButton.enabled = false
            EditSaveButton.title = " "
            displayEvent(self.event!)
        }
    }
    
    func displayEvent(event: Event){
        if let event = self.event, datelabel = dateLabel, descriptionTextField = descriptionTextField{
            self.descriptionTextField.text = event.eventDescription
            self.dateLabel.text = "Date: " + EventTableViewCell.dateFormatter.stringFromDate(event.Date!)
            self.addressLabel.text = "Address: " + event.Address!
            event.Icon!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let data = imageData {
                        let image = UIImage(data: imageData!)
                        self.eventImage.image = image
                        
                    }
                }
            }
            //Missing: Title & Address
            navBarTitle.title = event.Title
        }
    }
    
    @IBAction func EditMode(sender: AnyObject) {
        self.performSegueWithIdentifier("EditEvent", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let event = event {
            if PFUser.currentUser() != self.event!.objectForKey("User") as? PFUser{
                rsvpSegmentControl.hidden = true
                displayEvent(self.event!)
            }
        } else  if openbylink {
            println(eventId)
            ParseHelper.loadEvent(eventId){ (result: [AnyObject]?, error: NSError?) -> Void in
                let events = result as? [Event] ?? []
                if events != []{
                    self.event = events[0] as Event
                    self.displayEvent(self.event!)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditEvent"{
            let CreateEventViewController = segue.destinationViewController as! CreateEditEventViewController
            CreateEventViewController.event = event
            CreateEventViewController.host = host
        } else if segue.identifier == "Things"{
            let destinationviewcontroller = segue.destinationViewController as! ItemsTableViewController
            destinationviewcontroller.exists = true
            destinationviewcontroller.event = self.event
        }
    }


}