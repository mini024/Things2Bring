//
//  CreateEditEventViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/16/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class CreateEditEventViewController: UIViewController {
   
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var descriptionTextview: UITextView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var AddressTextField: UITextField!
    @IBOutlet var navBarTitle: UINavigationItem!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var things2Bring: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    
    var event: Event?
    var edit = false
    var popDatePicker : PopDatePicker?
    var newevent = Event()
    var items:[Items]?
    var host = false
    var saved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event{
            displayEvent(event)
            navBarTitle.title = "Edit Event"
            edit = true
            things2Bring.enabled = true
            inviteButton.enabled = true
        } else {
            eventImage.backgroundColor = UIColor.orangeColor()
            navBarTitle.title = "Create Event"
            things2Bring.enabled = false
            inviteButton.enabled = false
        }
         navigationController?.navigationItem.backBarButtonItem
        
        
        //MARK: TextField Delegates
        dateTextField.delegate = self
        titleTextField.delegate = self
        descriptionTextview.delegate = self
        AddressTextField.delegate = self
        
        
        descriptionTextview.textColor = UIColor.lightGrayColor()
        //MARK: Pop over
        popDatePicker = PopDatePicker(forTextField: dateTextField)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let event = event{
            //displayEvent(event)
            navBarTitle.title = "Edit Event"
            edit = true
        } else {
            eventImage.backgroundColor = UIColor.orangeColor()
            navBarTitle.title = "Create Event"
        }
        
        unlockTextFields()
    }
    
    @IBAction func InviteFriends(sender: AnyObject) {
        if !edit && !saved{
            SetEventValues(newevent)
            println(newevent)
            newevent.saveInBackground()
            event = newevent
            saved = true
        }
        performSegueWithIdentifier("InviteFriends", sender: self)
        
    }
    func SetEventValues(event2: Event){
        event2.Title = self.titleTextField.text
        event2.eventDescription = self.descriptionTextview.text
        event2.Date = EventTableViewCell.dateFormatter.dateFromString(self.dateTextField.text!)
        var imageData = UIImageJPEGRepresentation(self.eventImage.image, 0.8)
        event2.Icon = PFFile(data: imageData)
        event2.User = PFUser.currentUser()
        event2.Address = self.AddressTextField.text
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveEditedEvent"{
            let navController = segue.destinationViewController as! UINavigationController
            let EventDetailViewController = navController.topViewController as! EventViewController
            SetEventValues(self.event!)
            EventDetailViewController.event = self.event!
            EventDetailViewController.host = host
        } else if segue.identifier == "SettingIcon" && edit{
            let destinationController = segue.destinationViewController as! IconsCollectionViewController
            SetEventValues(self.event!)
            destinationController.event = self.event!
            destinationController.edit = true
        } else if segue.identifier == "AddItem"{
            let destinationController = segue.destinationViewController as! ItemsTableViewController
            destinationController.event = event
            destinationController.objectId = event?.objectId as String?
            destinationController.exists = edit
        } else if segue.identifier == "CancelCreatedEvent"{
            if let items = items {
                for i in 0...items.count - 1{
                    items[i].deleteInBackground()
                }
            }
            newevent.deleteInBackground()
        } else if segue.identifier == "CancelEditedEvent"{
            let navController = segue.destinationViewController as! UINavigationController
            let EventDetailViewController = navController.topViewController as! EventViewController
            EventDetailViewController.event = event
        } else if segue.identifier == "InviteFriends"{
            let InviteViewController = segue.destinationViewController as! InviteFriendsViewController
            InviteViewController.event = event
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("Exiting...")
    }
    
    @IBAction func Things2Bring(sender: AnyObject) {
        if !edit && !saved{
            SetEventValues(newevent)
            println(newevent)
            newevent.saveInBackground()
            event = newevent
            saved = true
        }
        performSegueWithIdentifier("AddItem", sender: self)
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        if edit{
            self.performSegueWithIdentifier("CancelEditedEvent", sender: self)
        } else{
            self.performSegueWithIdentifier("CancelCreatedEvent", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayEvent(event: Event){
        if let event = self.event, dateTextField = dateTextField, descriptionTextField = descriptionTextview, title = titleTextField{
            self.descriptionTextview.text = self.event!.eventDescription
            self.dateTextField.text = EventTableViewCell.dateFormatter.stringFromDate(event.Date!)
            //Getting the image from PFFile
            event.Icon!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let data = imageData {
                        let image = UIImage(data: imageData!)
                        self.eventImage.image = image
                    }
                }
            }
            self.titleTextField.text = event.Title
            self.AddressTextField.text = event.Address
            //Missing: Title & Address
            navBarTitle.title = event.Title
        }
    }
    
    //MARK: Saving to Parse
    
    @IBAction func SaveEvent(sender: AnyObject) {
        //MARK: Update event
        if let event = event {
        var query = PFQuery(className:"Event")
        query.getObjectInBackgroundWithId(event.objectId!) {
            (event: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let event = event {
                //Check This
                self.SetEventValues(event as! Event)
                event.saveInBackground()
                println(event.objectId)
                self.performSegueWithIdentifier("SaveEditedEvent", sender: self)
            }
        }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        unlockAddList()
    }
    
    //MARK: Pop Over Date Picker
    func resign() {
        dateTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        AddressTextField.resignFirstResponder()
    }
    
    func unlockAddList(){
        if let image = eventImage.image, title = titleTextField.text, address = AddressTextField.text, date = dateTextField.text{
            things2Bring.enabled = true
            inviteButton.enabled = true
        
        }
    }
    
    func unlockTextFields(){
        if let image = eventImage.image{
            titleTextField.enabled = true
            AddressTextField.enabled = true
            dateTextField.enabled = true
        }
    }
   
}

extension CreateEditEventViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        descriptionTextview.resignFirstResponder()
        unlockAddList()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == dateTextField {
            view2.hidden = false
        }
        unlockAddList()
    }
    
    
    //MARK: Pop Over Date Picker
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField === dateTextField) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = EventTableViewCell.dateFormatter.dateFromString(dateTextField.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
            }
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            unlockAddList()
            return false
        }
        else {
            unlockAddList()
            return true
        }
    }
}

extension CreateEditEventViewController: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        self.view.bounds.origin.y = 100
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.view.bounds.origin.y = 0
        self.resignFirstResponder()
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}





