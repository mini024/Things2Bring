//
//  ItemDetailTableViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/29/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit

class ItemDetailTableViewController: UITableViewController {
    
    var item: Items?
    var event: Event?
    var guestsforitem: [Guest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.title = item!.Item
        
        ParseHelper.ItemDetail(event!,item: item!){(result: [AnyObject]?, error: NSError?) -> Void in
            let guests = result as? [Guest] ?? []
                if guests.count != 0{
                    self.guestsforitem = guests
                }
            println(self.guestsforitem)
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func checkamount(index: Int) -> Int{
        var total = 1
        var elements = self.guestsforitem[index].items.count - 1
        for i in 0...self.guestsforitem.count - 1{
        var x = guestsforitem[index].items[i]
            for var a = i + 1 ; a<=elements; a++ {
                if x == guestsforitem[index].items[a]{
                    total++
                }
            }
        }
        return total
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return guestsforitem.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var number = checkamount(indexPath.row)
        var name:String = guestsforitem[indexPath.row].userId!.objectForKey("Name") as! String

        cell.textLabel!.text = name
        cell.detailTextLabel?.text = "\(number)"

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
