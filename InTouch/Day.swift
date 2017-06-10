//
//  Day.swift
//  InTouch
//
//  Created by Aalap Patel on 6/5/17.
//  Copyright © 2017 Aalap Patel. All rights reserved.
//

import UIKit

class Day: NSObject, NSCoding {
    
    let dayNum: Int
    let monthNum: Int
    let yearNum: Int
 
    
    init(day: Int, month: Int, year: Int) {
        dayNum = day
        monthNum = month
        yearNum = year
    }
    
    // Creates a "Day" object out of encoded data that was previously stored in the device
    required init(coder aDecoder: NSCoder) {
        dayNum = aDecoder.decodeInteger(forKey: "dayNum")
        monthNum = aDecoder.decodeInteger(forKey: "monthNum")
        yearNum = aDecoder.decodeInteger(forKey: "yearNum")
    }
    
    // Encodes and saves a "Day" object in the device
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dayNum, forKey: "dayNum")
        aCoder.encode(monthNum, forKey: "monthNum")
        aCoder.encode(yearNum, forKey: "yearNum")
    }
    
   }

