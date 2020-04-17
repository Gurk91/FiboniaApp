//
//  User.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 14/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation

class IntUser {
    
    var email: String
    var firstName: String
    var lastName: String
    var address: String
    var city: String
    var school: String
    var gradYear: String
    
    init(email: String, firstName: String, lastName: String, address: String, city: String, school: String, gradYear: String) {
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.city = city
        self.school = school
        self.gradYear = gradYear
    }
    
    func toDict() -> Dictionary<String, Any> {
        return ["email": self.email, "firstName": self.firstName, "lastName": self.lastName, "address": self.address, "city": self.city, "school": self.school, "gradYear": self.gradYear]
    }
    
    func updateAddress(add: String) {
        self.address = add
    }
    
    func updateAddress(add: String, cit: String) {
        self.address = add
        self.city = cit
    }
    
}
