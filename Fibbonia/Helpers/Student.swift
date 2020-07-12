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
    var address: String
    var city: String
    var zip: String
    var state: String
    var appointments: [[String: Any]]
    var tutor: Bool
    var calEmail: String
    var subjects: [String]
    var setPrefs: Bool
    var preferences: [String: Any]
    var stripeID: String
    var google: Bool
    var facebook: Bool
    
    init(fn: String, ln: String, eml: String, appt: [[String: Any]], subjects: [String], setPrefs: Bool, preferences: [String: Any], stripeID: String, google: Bool, facebook: Bool) {
        self.firstName = fn
        self.lastName = ln
        self.email = eml
        self.address = ""
        self.city = ""
        self.zip = ""
        self.state = ""
        self.appointments = appt
        self.tutor = false
        self.calEmail = ""
        self.subjects = subjects
        self.setPrefs = setPrefs
        self.preferences = preferences
        self.stripeID = stripeID
        self.google = google
        self.facebook = facebook
    }
    
    func addAppointment(appy: [String:Any]) {
        self.appointments.append(appy)
    }
    
    func setAddress(addr: String, cty: String, ste: String, zp: String) {
        self.address = addr
        self.city = cty
        self.state = ste
        self.zip = zp
    }
    
    func getData() -> [String:Any] {
        return ["email":self.email, "firstName":self.firstName, "lastName":self.lastName,
                "appointments": self.appointments, "tutor": self.tutor, "calEmail": self.calEmail,
                "address": self.address, "city": self.city, "state": self.state, "zip": self.zip, "subjects": self.subjects, "setPrefs": self.setPrefs, "preferences": self.preferences, "stripe_id": self.stripeID]
    }
    
    func setTutor(eml: String) {
        self.tutor = true
        self.calEmail = eml
    }
    
    
}
