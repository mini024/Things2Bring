//
//  HeaderTableViewCell.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/14/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor(red: 184, green: 233, blue: 134, alpha: 40)
        headerLabel.tintColor = UIColor(red: 65, green: 117, blue: 5, alpha: 100)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
