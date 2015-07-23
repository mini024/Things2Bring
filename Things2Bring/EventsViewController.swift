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
    var sectionHost:[Event] = []
    var section1Host:[Event] = []
    var section2Host:[Event] = []
    var section3Host:[Event] = []
    var sectionGuest:[Event] = []
    var section1Guest:[Event] = []
    var section2Guest:[Event] = []
    var section3Guest:[Event] = []
    var guest:[Guest] = []
    var segmentHost = true
    var load = false
    var selectedEvent = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.title = "Events"
        //MARK: TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        loadEvents()
        eventsGuest = []
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadEvents()
    }
    
    func loadEvents(){
        //MARK: Parse Helper Get Events
        ParseHelper.loadEvents{(result: [AnyObject]?, error: NSError?) -> Void in
            self.events = result as? [Event] ?? []
            self.tableView.reloadData()
            }

        //MARK: Parse Helper Get Guest Events
       ParseHelper.loadGuestEvents{(result: [AnyObject]?, error: NSError?) -> Void in
            self.guest = result as? [Guest] ?? []
            println(self.guest[0].objectForKey("Event"))
                for index in 0...self.guest.count - 1 {
                    var event = self.guest[index].objectForKey("Event") as! Event
                    self.eventsGuest.append(event)
                }
        }
    }

    @IBAction func changingsection(sender: AnyObject) {
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
            let navController = segue.destinationViewController as! UINavigationController
            let EventDetailViewController =  navController.topViewController as! EventViewController
            EventDetailViewController.event = selectedEvent
            if segmentHost == false{
                EventDetailViewController.EditSaveButton.title = " "
            } else{
                EventDetailViewController.host = true
            }
        } else if segue.identifier == "CreateEvent"{
            
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

        cell.event = TextItem
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
            var eventdate = NSDate()
            if !segmentHost{
                eventdate = (eventsGuest[i].objectForKey("Date") as? NSDate)!
            } else {
                eventdate = (events[i].objectForKey("Date") as? NSDate)!
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
            if sectionEvent == section{
                if segmentHost{
                    switch (section) {
                    case 0:
                        sectionHost = sectionEvents
                    case 1:
                        section1Host = sectionEvents
                    case 2:
                        section2Host = sectionEvents
                    case 3:
                        section3Host = sectionEvents
                    default:
                        section3Host = sectionEvents
                    }
                } else{
                    switch (section) {
                    case 0:
                        sectionGuest = sectionEvents
                    case 1:
                        section1Guest = sectionEvents
                    case 2:
                        section2Guest = sectionEvents
                    case 3:
                        section3Guest = sectionEvents
                    default:
                        section3Guest = sectionEvents
                    }
                }
            }
        }

            return sectionEvents
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderTableViewCell
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Today"
        case 1:
            headerCell.headerLabel.text = "This Week"
        case 2:
            headerCell.headerLabel.text = "Next Week"
        default:
            headerCell.headerLabel.text = "Next Month"
        }
        
        return headerCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var section = indexPath.section
        var row = indexPath.row

        var TextItem: Event = events[row] as Event

        if segmentHost{
            switch (section) {
                case 0:
                    TextItem = sectionHost[row] as Event
                case 1:
                    TextItem = section1Host[row] as Event
                case 2:
                    TextItem = section2Host[row] as Event
                default:
                    TextItem = section3Host[row]
            }
        } else{
            switch (section) {
            case 0:
                TextItem = sectionGuest[row] as Event
            case 1:
                TextItem = section1Guest[row] as Event
            case 2:
                TextItem = section2Guest[row] as Event
            default:
                TextItem = section3Guest[row] as Event
            }
        }

        selectedEvent = TextItem
        
        self.performSegueWithIdentifier("EventDetail", sender: self) 
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            //MARK : Delete Event from Parse
            var deleteEvent = Event()
            
            var section = indexPath.section
            var row = indexPath.row
            
            var TextItem: Event = events[row] as Event
            
            if segmentHost{
                switch (section) {
                case 0:
                    TextItem = sectionHost[row] as Event
                    sectionHost.removeAtIndex(row)
                case 1:
                    TextItem = section1Host[row] as Event
                    section1Host.removeAtIndex(row)
                case 2:
                    TextItem = section2Host[row] as Event
                    section2Host.removeAtIndex(row)
                default:
                    TextItem = section3Host[row]
                    section3Host.removeAtIndex(row)
                }
                events.removeAtIndex(row)
            } else{
                switch (section) {
                case 0:
                    TextItem = sectionGuest[row] as Event
                    sectionGuest.removeAtIndex(row)
                case 1:
                    TextItem = section1Guest[row] as Event
                    section1Guest.removeAtIndex(row)
                case 2:
                    TextItem = section2Guest[row] as Event
                    section2Guest.removeAtIndex(row)
                default:
                    TextItem = section3Guest[row] as Event
                    section3Guest.removeAtIndex(row)
                }
                eventsGuest.removeAtIndex(row)
            }
            
            //Check For Delete Event && Items of Event   
            ParseHelper.DeleteEvent(TextItem)
            tableView.reloadData()
        }
    }
    
}



