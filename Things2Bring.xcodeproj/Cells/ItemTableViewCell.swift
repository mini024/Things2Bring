//
//  ItemTableViewCell.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/17/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var totlaLabel: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var stepper: UIStepper!
    
    var item: Items?{
        didSet{
            if let item = item{
            itemLabel.text = item.objectForKey("Item") as? String
            var total = item.objectForKey("Total") as! Float
            var subtotal = item.objectForKey("Recolected") as! Float
            progressbar.progress = subtotal/total
            totlaLabel.text = "\(Int(subtotal))" + "/" + "\(Int(total))"
            stepper.maximumValue = Double(total)
            stepper.minimumValue = Double(subtotal)
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
