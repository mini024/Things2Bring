//
//  ItemsTableViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/17/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class ItemsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var event: Event?
    var items:[Items] = []
    var add = 0
    var edit = false //Editing list
    var exists = false // Editing Events List
    var objectId: String?
    var taking:[Items] = []
    var itemsinevent:[Items] = []
    var selectedItem:Items?
    var selectedItemrow:Int?
    
    @IBOutlet var addbutton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var addItemStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemStepper.maximumValue = 20
        //MARK: Get Items from Parse if Event exists
        if exists{
            ParseHelper.loadItem(event!){(result: [AnyObject]?, error: NSError?) -> Void in
                self.items = result as? [Items] ?? []
                if error != nil{
                    println(error)
                } else {
                    println(self.items)
                    self.tableView.reloadData()
                }
            }
             view2.hidden = true
        } else {
            addbutton.title = "Done"
            edit = true
            view2.hidden = false
        }
        checkingifhost()
        itemNameTextField.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if exists{
            ParseHelper.loadItem(event!){(result: [AnyObject]?, error: NSError?) -> Void in
                self.items = result as? [Items] ?? []
                if error != nil{
                    println(error)
                } else {
                    println(self.items)
                    self.tableView.reloadData()
                }
            }
            view2.hidden = true
        } else {
            addbutton.title = "Done"
            edit = true
            view2.hidden = false
        }
        checkingifhost()
        itemNameTextField.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        println(taking)
        if taking.count != 0{
            ParseHelper.Bringing(event!, taking: taking)
            taking = []
        }
    }
    
    func checkingifhost(){
        if PFUser.currentUser() != event?.objectForKey("User") as? PFUser{
            addbutton.title = ""
            addbutton.enabled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ItemDetail"{
            let destinationviewcontroller = segue.destinationViewController as! ItemDetailTableViewController
            selectedItem = items[selectedItemrow!]
            destinationviewcontroller.item = selectedItem
            destinationviewcontroller.event = event
        }
    }
    
    //MARK: NavBar Button
    @IBAction func Edit(sender: AnyObject) {
        if addbutton.title == "Edit"{
            edit = true
            view2.hidden = false
            tableView.numberOfRowsInSection(0)
            tableView.reloadData()
            addbutton.title = "Done"
        } else {
            view2.hidden = true
            edit = false
            addbutton.title = "Edit"
            tableView.reloadData()
//            if itemsinevent.count != 0 {
//                var query = PFQuery(className:"Event")
//                query.getObjectInBackgroundWithId(event!.objectId!) {
//                    (itemm: PFObject?, error: NSError?) -> Void in
//                    if error != nil {
//                        println(error)
//                    } else if let itemm = itemm {
//                        itemm.items
//                        itemm.saveInBackground()
//                    }
//                }
//            }
        }
    }
    
    //MARK: AddItem View
    @IBAction func CancelItem(sender: AnyObject) {
        view2.hidden = true
        itemNameTextField.text = " "
        addItemStepper.value = 0
        itemNameTextField.resignFirstResponder()
    }
    
    func SetAddItem(item: Items){
        item["Item"] = itemNameTextField.text
        item["Total"] = addItemStepper.value
        item["Recolected"] = 0
        item.event = event!
        items.append(item)
        item.saveInBackground()
        itemsinevent.append(item)
    }
    
    @IBAction func addTotal(sender: UIStepper!) {
        totalLabel.textColor = UIColor.blackColor()
        totalLabel.text = "Total: " + "\(sender.value)"
        itemNameTextField.resignFirstResponder()
    }
    
    @IBAction func AddItem(sender: AnyObject) {
        //MARK: Pop Add Item
        if (itemNameTextField.text != "" || itemNameTextField.text != " ") && addItemStepper.value != 0{
            exists = true
            var item = Items()
            SetAddItem(item)
            itemNameTextField.resignFirstResponder()
            itemNameTextField.text = " "
            addItemStepper.value = 0
            totalLabel.text = "Total:"
            addbutton.title = "Done"
            view2.hidden = true
            tableView.reloadData()
        }  else if (itemNameTextField.text == "" || itemNameTextField.text == " ") && addItemStepper.value == 0{
            totalLabel.textColor = UIColor.redColor()
            totalLabel.text = "Total is 0?"
            itemNameTextField.attributedPlaceholder =  NSAttributedString(string:"Enter item",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        } else if itemNameTextField.text == "" || itemNameTextField.text == " "{
            itemNameTextField.attributedPlaceholder =  NSAttributedString(string:"Enter item",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        } else if addItemStepper.value == 0{
            totalLabel.textColor = UIColor.redColor()
            totalLabel.text = "Total is 0?"
        }
    }

    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Stepper Action in Cell
    func tagged(sender: UIStepper!){
        let button = sender as UIStepper
        let view = button.superview!
        let cell = view.superview as! ItemTableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let item = items[indexPath!.row]
        
        var total = item["Total"] as! Float
        var subtotal = sender.value
        cell.progressbar.progress = Float(sender.value)/total
        cell.totlaLabel.text = "\(Int(subtotal))" + "/" + "\(Int(total))"
        item.recolected = Int(Float(sender.value))
        taking.append(item)
        
        var query = PFQuery(className:"Items")
        query.getObjectInBackgroundWithId(item.objectId!) {
            (itemm: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let itemm = itemm {
                itemm["Item"] = item.objectForKey("Item")
                itemm["Recolected"] = item.recolected
                itemm.saveInBackground()
            }
        }
        
    }
}

// MARK:Table view data source
extension ItemsTableViewController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if edit && exists{
            return items.count + 1
        } else if exists{
            return items.count
        } else if !exists && !edit{
            return 0
        } else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if exists{
            if indexPath.row == items.count {
                var cell2 = tableView.dequeueReusableCellWithIdentifier("AddItemCell", forIndexPath: indexPath) as! AddItemsTableViewCell
                return cell2
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
                var row = indexPath.row
                cell.stepper.addTarget(self, action: "tagged:", forControlEvents: UIControlEvents.ValueChanged)
                cell.item = items[row]
                
                return cell
            }
        } else {
            if edit{
            let cell = tableView.dequeueReusableCellWithIdentifier("AddItemCell", forIndexPath: indexPath) as! AddItemsTableViewCell
            
            return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(" ", forIndexPath: indexPath) as! UITableViewCell
                
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == items.count - 1 && !edit{
            selectedItemrow = indexPath.row
            performSegueWithIdentifier("ItemDetail", sender: self)
        } else if indexPath.row == items.count && edit{
            view2.hidden = false
            addbutton.enabled = false
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            selectedItemrow = indexPath.row
            performSegueWithIdentifier("ItemDetail", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if PFUser.currentUser() == self.event!.objectForKey("User") as? PFUser{
            if (editingStyle == .Delete) {
                var row = indexPath.row
                var item = items[row]
                items.removeAtIndex(row)
                item.deleteInBackground()
                tableView.reloadData()
            }
        }
    
    }

}


//MARK: Text Fields Delegate
extension ItemsTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        itemNameTextField.attributedPlaceholder =  NSAttributedString(string:"Item Name",
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}