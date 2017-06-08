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
    var entries: Array<String>
    var isComplete: Bool
    
    init(day: Int, month: Int, year: Int) {
        dayNum = day
        monthNum = month
        yearNum = year
        isComplete = false
        entries = Array(repeating: "", count: 3)
    }
    
    // Creates a "Day" object out of encoded data that was previously stored in the device
    required init(coder aDecoder: NSCoder) {
        dayNum = aDecoder.decodeInteger(forKey: "dayNum")
        monthNum = aDecoder.decodeInteger(forKey: "monthNum")
        yearNum = aDecoder.decodeInteger(forKey: "yearNum")
        entries = aDecoder.decodeObject(forKey: "entries") as! [String]
        isComplete = aDecoder.decodeBool(forKey: "isComplete")
    }
    
    // Encodes and saves a "Day" object in the device
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dayNum, forKey: "dayNum")
        aCoder.encode(monthNum, forKey: "monthNum")
        aCoder.encode(yearNum, forKey: "yearNum")
        aCoder.encode(entries, forKey: "entries")
        aCoder.encode(isComplete, forKey: "isComplete")
    }
    
    // Sets "isComplete" to true if the user wrote every entry for the certain day
   }

