//
//  Student.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 26/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation

class Student {
    
    var firstName: String
    var lastName: String
    var email: String
    var appointments: [[String: Any]]
    var tutor: Bool
    var calEmail: String
    var subjects: [String]
    //var setPrefs: Bool
    //var preferences: [String: Any]
    var stripeID: String
    var accntType: String
    var update_classes: [String]
    var firstlogin: Bool
    var img: String
    
    init(fn: String, ln: String, eml: String, appt: [[String: Any]], subjects: [String], stripeID: String, accntType: String, firstlogin: Bool) {
        self.firstName = fn
        self.lastName = ln
        self.email = eml
        self.appointments = appt
        self.tutor = false
        self.calEmail = ""
        self.subjects = subjects
        //self.setPrefs = setPrefs
        //self.preferences = preferences
        self.stripeID = stripeID
        self.accntType = accntType
        self.update_classes = []
        self.firstlogin = firstlogin
        self.img = ""
    }
    
    func addAppointment(appy: [String: Any]) {
        self.appointments.append(appy)
    }
    
    
    func getData() -> [String:Any] {
        return ["email":self.email, "firstName":self.firstName, "lastName":self.lastName,
                "appointments": self.appointments, "tutor": self.tutor, "calEmail": self.calEmail,
                "subjects": self.subjects, "stripe_id": self.stripeID]
    }
    
    func setTutor(eml: String) {
        self.tutor = true
        self.calEmail = eml
    }
    
    
}
