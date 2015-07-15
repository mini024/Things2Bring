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
    
    @IBOutlet weak var EditSaveButton: UIBarButtonItem!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var friendsGoingButton: UIButton!
    @IBOutlet weak var thingsListButton: UIButton!
    @IBOutlet weak var rsvpSegmentControl: UISegmentedControl!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var event = Event()
    
    @IBAction func EditMode(sender: AnyObject) {
        if (EditSaveButton.title == "Edit"){
            EditSaveButton.title = "Save"
            containerView.hidden = false
        } else {
            //MARK: Save Event to Parse
            //MARK: Save Changes if it exists
        }
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }


}