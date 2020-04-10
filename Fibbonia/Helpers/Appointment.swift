//
//  Appointment.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 8/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation

class Appointment {
    
    var email: String
    var tutorFN: String
    var tutorLN: String
    var time: Date
    var location: String
    var className: String
    var notes: String
    
    init(tutorEmail: String, tutorFN: String, tutorLN: String, time: Date, location: String, className: String, notes: String) {
        self.email = tutorEmail
        self.tutorFN = tutorFN
        self.tutorLN = tutorLN
        self.time = time
        self.location = location
        self.className = className
        self.notes = notes
    }
    
    func toDict() -> Dictionary<String, Any>{
        return ["tutorEmail": self.email, "tutorFN": self.tutorFN, "tutorLN": self.tutorLN, "time": self.time, "location": self.location, "classname": self.className, "notes": self.notes]
    }
    
}
