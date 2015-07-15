//
//  EventTableViewCell.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/13/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        }()
    
    var event: Event?{
        didSet{
            if let event = event, datelabel = datelabel, titleLabel = titleLabel{
                self.titleLabel.text = event.title
                self.datelabel.text = EventTableViewCell.dateFormatter.stringFromDate(event.date!)
                
                event.icon!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let data = imageData {
                            let image = UIImage(data: imageData!)
                            self.iconImage.image = image
                            
                        }
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
