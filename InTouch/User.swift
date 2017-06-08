//
//  User.swift
//  InTouch
//
//  Created by Aalap Patel on 6/5/17.
//  Copyright © 2017 Aalap Patel. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    
    var days = [String: Day]()
    var startDate = Calendar.current.startOfDay(for: Date())
    var hasReminder = false
    var reminderTime = ""
    var color = UIColor(hexString: "#4A86E8")
 
    static var sharedUser = User(rand: 13)
    private init(rand: Int) { }
    
    // Creates a "User" object out of encoded data that was previously stored in the device
    required init(coder aDecoder: NSCoder) {
        days = aDecoder.decodeObject(forKey: "days") as! [String: Day]
        startDate = aDecoder.decodeObject(forKey: "startDate") as! Date
        hasReminder = aDecoder.decodeBool(forKey: "hasReminder")
        reminderTime = aDecoder.decodeObject(forKey: "reminderTime") as! String
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
    }
    
    // Encodes and saves a "User" object in the device
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: "days")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(hasReminder, forKey: "hasReminder")
        aCoder.encode(reminderTime, forKey: "reminderTime")
        aCoder.encode(color, forKey: "color")
    }
    
    // Adds xp to the user and levels the user up if applicable
   
}
