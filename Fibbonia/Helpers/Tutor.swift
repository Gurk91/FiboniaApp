//
//  Tutor.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 20/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation
import Firebase


class Tutor {
    
    var calEmail: String
    var GPA: Double
    var gradYear: Int
    var major: String
    var classes: [String]
    var rating: Double
    var experience: Int
    var address: String
    var city: String
    var state: String
    var phone: String
    var name: String
    var online: String
    var appointments: [[String: Any]]
    //var classRating: [String: Double]
    var subjects: [String]
    
    init(name: String ,calEmail: String, GPA: Double, gradYear: Int, major: String, subjects: [String]) {
        self.name = name
        self.calEmail = calEmail
        self.GPA = GPA
        self.gradYear = gradYear
        self.major = major
        self.classes = []
        self.rating = 0.0
        self.experience = 0
        self.address = ""
        self.city = ""
        self.state = ""
        self.phone = ""
        self.online = ""
        self.appointments = [["ABC":"DEF"]]
        self.subjects = subjects
        
        //self.classRating = [:]
    }
    
    func addClass(clas: String) {
        self.classes.append(clas)
    }
    
    func rateTutor(rate: Double) {
        self.experience += 1
        let newRating = (self.rating + rate) / Double(self.experience)
        self.rating = newRating
    }
    
    func getData() -> [String:Any] {
        return ["name": self.name, "email":self.calEmail, "GPA": self.GPA, "Major": self.major, "classes": self.classes, "rating": self.rating, "experience": self.experience,
                "address": self.address, "city": self.city, "state": self.state, "onlineID": self.online, "appointments": self.appointments, "subjects": self.subjects]
    }
    
    
    func setAddress(addr: String, cty: String, ste: String) {
        self.address = addr
        self.city = cty
        self.state = ste
    }
    
    func setOnline(ID: String) {
        self.online = ID
    }
    
    func newAppt(appt: [String: Any]) {
        self.appointments.append(appt)
    }
    
    func setFirebaseData() {
        let db = Firestore.firestore()
        db.collection("tutors")
            .document(self.calEmail)
            .getDocument { (document, error) in
            
            // Check for error
            if error == nil {
                
                // Check that this document exists
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    self.classes = documentData!["classes"] as! [String]
                    self.GPA = documentData!["GPA"] as! Double
                    self.gradYear = documentData!["GradYear"] as! Int
                    self.major = documentData!["major"] as! String                    
                }
                
            }
            
        }
    }
    
}
