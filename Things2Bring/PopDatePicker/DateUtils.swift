//
//  DateUtils.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 02/10/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import Foundation

extension NSDate {
    
    // -> Date System Formatted Medium
    func ToDateMediumString() -> NSString? {
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        return formatter.stringFromDate(self)
    }
}