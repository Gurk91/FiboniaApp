//
//  Tutor.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 20/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation


class Tutor {
    
    var calEmail: String
    var GPA: Double
    var gradYear: Int
    var major: String
    var classes: [String]
    var rating: Double
    var experience: Int
    
    init(calEmail: String, GPA: Double, gradYear: Int, major: String) {
        self.calEmail = calEmail
        self.GPA = GPA
        self.gradYear = gradYear
        self.major = major
        self.classes = []
        self.rating = 0.0
        self.experience = 0
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
        return ["email":self.calEmail, "GPA": self.GPA, "Major": self.major, "classes": self.classes, "rating": self.rating, "experience": self.experience]
    }
    
}
