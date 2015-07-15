//
//  ViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/13/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class EventsViewController: UIViewController {
    @IBOutlet var segmentControlHostGuest: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var events:[Event] = []
    var eventsGuest:[Event] = []
    var guest:[Guest] = []
    var segmentHost = true
    var load = false
    var selectedEvent = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        println(PFUser.currentUser()?.objectId)
    }
    
    override func viewDidAppear(animated: Bool) {
        loadEvents()
    }
    
    func loadEvents(){
        //MARK: Parse Getting Host Events
        var queryEventsHost = Event.query()
        queryEventsHost!.whereKey("User", equalTo: PFUser.currentUser()!)
        queryEventsHost!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.events = result as? [Event] ?? []
            self.tableView.reloadData()
        }
        
        //MARK: Parse Getting Guest Events
        var queryEventsGuest = Guest.query()
        queryEventsGuest!.whereKey("userId", equalTo: PFUser.currentUser()!)
        queryEventsGuest!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.guest = result as? [Guest] ?? []
            println(self.guest)
                for index in 0...self.guest.count - 1 {
                    var query = Event.query()
                    query!.whereKey("objectId", equalTo: self.guest[index].objectForKey("eventId")!)
                    query!.findObjectsInBackgroundWithBlock( {(result: [AnyObject]?, error: NSError?) -> Void in
                        self.eventsGuest += result as? [Event] ?? []
                    })
                }
        }
    }

    @IBAction func loadNewEvents(sender: AnyObject) {
        if segmentControlHostGuest.selectedSegmentIndex == 0{
            segmentHost = true
            tableView.reloadData()
        } else {
            segmentHost = false
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventDetail"{
            let EventDetailViewController = segue.destinationViewController as! EventViewController
            EventDetailViewController.event = selectedEvent
        }
    }

}


//MARK: Table View
extension EventsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getSectionItems(section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        let sectionItems = self.getSectionItems(indexPath.section) as [Event]
        let TextItem: Event = sectionItems[indexPath.row] as Event
        
        let newevent = Event()
        newevent.title =  TextItem.objectForKey("Title") as! String
        newevent.date = TextItem.objectForKey("Date") as? NSDate
        newevent.eventDescrption = TextItem.objectForKey("Description") as! String
        newevent.icon = TextItem.objectForKey("Icon") as? PFFile
        
        cell.event = newevent
        println(cell.event)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView2: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView2: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Today"
        }
        else if section == 1 {
            return "This Week"
        }
        else if section == 2 {
            return "Next Week"
        }
        else {
            return "Next Month"
        }
    }
    
    func getSectionItems(section: Int) -> [Event]{
        var sectionEvents:[Event] = []
        var numberofEvents = self.events.count
        
        if !segmentHost{
            numberofEvents = self.eventsGuest.count
            println("Guest Events")
            println(eventsGuest)
        }
        var sectionEvent = 0

        for var i = 0; i<numberofEvents; i += 1 {
            //MARK: Getting current Date
            var eventdate = (events[i].objectForKey("Date") as? NSDate)!
            if !segmentHost{
                eventdate = (eventsGuest[i].objectForKey("Date") as? NSDate)!
            }
            
            var date = NSDate()
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
            let componentsEvent = calendar.components(.CalendarUnitMonth | .CalendarUnitDay, fromDate: eventdate)
            
            let month = components.month
            let day = components.day
            let monthEvent = componentsEvent.month
            let dayEvent = componentsEvent.day
            
            //Compare dates to get correct section
            if (monthEvent == month && dayEvent == day){
                sectionEvent = 0
            } else if (monthEvent == month && dayEvent > day){
                if (dayEvent - day) >= 7 && (dayEvent - day) < 14{
                    sectionEvent = 2
                } else {
                    sectionEvent = 1
                }
            } else if ( monthEvent > month){
                if monthEvent - month == 1{
                sectionEvent = 3
                }
            } else {
                sectionEvent = 5
            }
            
            if sectionEvent == section{
                if segmentHost{
                   sectionEvents.append(events[i])
                } else{
                   sectionEvents.append(eventsGuest[i])
                }
            }
        }
            return sectionEvents
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Today";
        case 1:
            headerCell.headerLabel.text = "This Week";
        case 2:
            headerCell.headerLabel.text = "Next Week";
        default:
            headerCell.headerLabel.text = "Next Month";
        }
        
        return headerCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var clicked = "\(indexPath.section)" + " & " + "\(indexPath.row)"
        let cell =  tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        println(clicked)
        if (segmentHost){
            selectedEvent = cell.event!
        } else{
             selectedEvent = eventsGuest[indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            //MARK : Delete Event from Parse
            var deleteEvent = Event()
            deleteEvent.deleteInBackground()
            loadEvents()
            tableView.reloadData()
        }
    }
    
}



