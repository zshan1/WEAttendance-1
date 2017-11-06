//
//  MonitoringRegion.swift
//  WEAttendance
//
//  Created by Neal Zhu on 11/6/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import Foundation


class MonitoringRegion: NSObject, NSCoding {
    
    var date: Date
    init(date: Date){
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = (aDecoder.decodeObject(forKey: "date") as? Date)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
    }
}


