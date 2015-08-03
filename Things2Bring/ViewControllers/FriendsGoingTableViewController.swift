//
//  FriendsGoingTableViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/28/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class FriendsGoingTableViewController: UITableViewController {
    
    var event: Event?
    var users:[String]?
    var usersGoing:[String] = []
    var usersMaybe:[String] = []
    var usersCant:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsgoing(event!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func friendsgoing(event: Event){
        var users:[PFUser] = []
        var guestquery = Guest.query()
        guestquery?.whereKey("event", equalTo: event)
        guestquery?.includeKey("userId")
        guestquery?.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            let guests = result as? [Guest] ?? []
            if guests.count != 0{
                println(guests)
                for index in 0...guests.count - 1 {
                    var eventt = guests[index].event
                    if guests[index].rsvp == 0{
                        self.usersGoing.append(guests[index].userId!.objectForKey("Name") as! String)
                    } else if  guests[index].rsvp == 1{
                        self.usersMaybe.append(guests[index].userId!.objectForKey("Name") as! String)
                    } else{
                        self.usersCant.append(guests[index].userId!.objectForKey("Name") as! String)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            if usersGoing.count != 0{
                return usersGoing.count
            } else{
                return 0
            }
        case 1:
            if usersGoing.count != 0{
                return usersMaybe.count
            } else{
                return 0
            }
        case 2:
            if usersGoing.count != 0{
                return usersCant.count
            } else{
                return 0
            }
        default:
            return users!.count
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Going"
        case 1:
            return "Maybe"
        case 2:
            return "Can't Go"
        default:
            return "Other"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Friend", forIndexPath: indexPath) as! UITableViewCell
        
        var section = indexPath.section
        var row = indexPath.row
        
        switch section{
        case 0:
            cell.textLabel!.text = usersGoing[row]
        case 1:
            for index in 0...usersMaybe.count - 1 {
                cell.textLabel!.text = usersMaybe[row]
            }
        case 2:
            for index in 0...usersCant.count - 1 {
                cell.textLabel!.text = usersCant[row]
            }
        default:
            for index in 0...usersGoing.count - 1{
                cell.textLabel!.text = usersGoing[row]
            }
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
