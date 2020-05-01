//
//  Constants.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 18/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation

struct Constants {
    
    static let states = ["Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut", "Delaware",
    "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
    "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan",
    "Minnesota", "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas",
    "Utah", "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming"]
    
    static let subjects = ["---","EECS", "Economics", "Math", "Physics"]
    static let EECSsubjects = ["---", "CS61A", "CS61B", "CS61C", "CS70",
                                "EE16A", "EE16B", "CS170", "CS188", "CS189"]
    static let econSubjects = ["---", "Econ 1", "Econ 2", "Econ C3", "Econ 100A",
                               "Econ 100B","Econ 101A", "Econ 101B"]
    static let mathSubjects = ["---", "Math 1A", "Math 1B", "Math 53", "Math 54", "Math 110"]
    static let physicsSubjects = ["---", "Physics 5A", "Physics 5B", "Physics 5C",
                                  "Physics 7A", "Physics 7B", "Physics 7C"]
    
    static let emptyList = ["---", "---","---", "---", "---", "---", "---", "---", "---", "---",
                            "---", "---", "---", "---", "---", "---", "---", "---", "---", "---"]
    
    struct Storyboard {
        static let homeViewController = "HomeVC"
        static let viewController = "genVC"
        static let tabBarCont = "tabBarID"
        static let tutorSignUpVC = "TutorSUVC"
        static let tutorHomeVC = "TutorHomeVC"
        static let tlist2Class = "TlistToDetail"
        
    }
    
    struct tutorField {
        var name: String
        var rating: String
        var price: String
    }
}
