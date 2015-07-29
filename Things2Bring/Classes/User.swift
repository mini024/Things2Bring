//
//  User.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/15/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Bolts

class User: PFUser{
    @NSManaged var Name: String
    //@NSManaged var username: String?
    // 4
    override init () {
        super.init()
        
        
    }
    
    override static func parseClassName() -> String {
        return "_User"
    }
    

}
