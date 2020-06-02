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
    var name: String
    var time: Date
    var studentTimeZone: String
    var location: String
    var className: String
    var notes: String
    var studentName: String
    var selfEmail: String
    var uid: String
    var subject: String
    
    init(tutorEmail: String, name: String, time: Date, location: String, className: String, notes: String, studentName: String, selfEmail: String, uid: String, timezone: String, subject: String) {
        self.email = tutorEmail
        self.name = name
        self.time = time
        self.location = location
        self.className = className
        self.notes = notes
        self.studentName = studentName
        self.selfEmail = selfEmail
        self.uid = uid
        self.studentTimeZone = timezone
        self.subject = subject
    }
    
    func toDict() -> Dictionary<String, Any>{
        return ["tutorEmail": self.email, "tutorFN": self.name, "time": self.time, "location": self.location, "classname": self.className, "notes": self.notes, "studentName": self.studentName, "studentEmail": self.selfEmail, "uid": self.uid, "timezone": self.studentTimeZone, "subject": self.subject]
    }
    
}
