//
//  IconsCollectionViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/17/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse

class IconsCollectionViewController: UIViewController {
    var icons:[Icons] = []
    var selectedimage: UIImage?
    var event = Event()
    var selected: Int?
    var edit = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Load Icons from Parse
        let query = PFQuery(className: "Icons")
        query.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            self.icons = result as? [Icons] ?? []
            self.collectionView?.reloadData()
            print(self.icons)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UploadImage(sender: UIButton!){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseIcon"{
            if edit{
                let destinationcontroller = segue.destinationViewController as! CreateEditEventViewController
                    //MARK: CHANGE HERE!
//                        var newevent = Event()
//                        newevent.equal(self.event)
//                        newevent.Title = self.event.Title
//                        newevent.Icon = self.icons[self.selected!].objectForKey("Icon")! as? PFFile
//                        newevent.Description = self.event.Description
//                        newevent.Date = self.event.Date
//                        newevent.User = PFUser.currentUser()
//                        newevent.Address = self.event.Address
                        //destinationcontroller.eventImage.image = image
                        destinationcontroller.event! = self.event
            
                
            } else{
                let destinationcontroller = segue.destinationViewController as! CreateEditEventViewController
                self.icons[self.selected!].objectForKey("Icon")!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let data = imageData {
                            let image = UIImage(data: imageData!)
                            destinationcontroller.eventImage.image = image
                        }
                    }
                }
            }
        }
    }

}

extension IconsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return icons.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < icons.count{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("IconCell", forIndexPath: indexPath) as! IconCollectionViewCell
            icons[indexPath.row].objectForKey("Icon")!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let data = imageData {
                        let image = UIImage(data: imageData!)
                        cell.iconImage.image = image
                        
                    }
                }
            }
            var xpos = (view.frame.width/3)*CGFloat(indexPath.row)
            var ypos = cell.frame.origin.y
            var line = indexPath.row/3
            //print(indexPath.row)
            
            if Double(indexPath.row/3)>=1.0{
                ypos = (view.frame.width/3)*CGFloat(line)
                if indexPath.row % 3 == 0 {
                    xpos = 0
                } else {
                    xpos = (view.frame.width/3)*CGFloat(indexPath.row - 3)
                }
            }
            cell.frame = CGRectMake(xpos, ypos, view.frame.width/3, view.frame.width/3)
            return cell
        } else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UploadIconCell", forIndexPath: indexPath) as! UploadIconCollectionViewCell
            cell.uploadButton.backgroundColor = UIColor.whiteColor()
            cell.uploadButton.addTarget(self, action: "UploadImage:", forControlEvents: UIControlEvents.TouchDown)
            var xpos = (view.frame.width/3)*CGFloat(indexPath.row)
            var ypos = cell.frame.origin.y
            var line = indexPath.row/3
            print(indexPath.row)
            
            if Double(indexPath.row/3)>=1.0{
                ypos = (view.frame.width/3)*CGFloat(line)
                if indexPath.row % 3 == 0 {
                    xpos = 0
                } else {
                    xpos = (view.frame.width/3)*CGFloat(indexPath.row - 3)
                }
            }
            cell.frame = CGRectMake(xpos, ypos, view.frame.width/3, view.frame.width/3)
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selected = indexPath.row
        performSegueWithIdentifier("ChooseIcon", sender: self)
    }

}