//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SwiftyJSON
import Alamofire
import Stripe

class Utils {
    
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 146/255, blue: 255/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 0/255, green: 146/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.init(red: 0/255, green: 146/255, blue: 255/255, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.black
    }
    
    static func styleHollowDeleteButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.init(red: 247/255, green: 71/255, blue: 10/255, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.black
    }
    
    static func styleFilledGreenButton(_ button: UIButton) {
        button.backgroundColor =  UIColor.init(red: 25/255, green: 179/255, blue: 4/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func validCalEmail(email: String) -> Bool {
        
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: ".*(@berkeley.edu)$")
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    static func validPhone(phone: String) -> Bool {
        
        let range = NSRange(location: 0, length: phone.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]{10}$")
        return regex.firstMatch(in: phone, options: [], range: range) != nil
    }
    
    static func getClasses(subject: String) -> [String] {
        if subject == "EECS" {
            return Constants.EECSsubjects
        }
        if subject == "Economics" {
            return Constants.econSubjects
        }
        if subject == "Math" {
            return Constants.mathSubjects
        } else {
            return Constants.physicsSubjects
        }
    }
    
    static func Connection() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    enum NetworkError: Error {
        case badURL, requestFailed, unknown
    }


    static func fetchData(from urlString: String, completion: @escaping (Result<JSON, NetworkError>) -> Void) {
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                
                   do {
                      let data = try Data(contentsOf: url, options: .alwaysMapped)
                      let jsonObj = try JSON(data: data)
                    let relevant = jsonObj["courses"]
                    //print(relevant)
                    //self.output = relevant
                    completion(.success(relevant))
                   } catch let error {
                      print(error)
                   }
                }else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
        
    
    static func organizeSubjects(){
        for cell in Constants.pulledOutput{
            let subject = cell.1["abbreviation"].rawString()!
            //print("thats what she said")
            if Constants.pulledSubjects.contains(subject) {
                continue
            } else {
                Constants.pulledSubjects.append(subject)
                Constants.pulledClasses[subject] = []
            }
        }
        //print("subjects: ", Constants.pulledSubjects)
        print("subject list organized")
    }
    
    static func organizeClasses(){
        for cell in Constants.pulledOutput{
            //print("gabagool")
            let subject = cell.1["abbreviation"].rawString()!
            let number = cell.1["course_number"].rawString()!
            if Constants.pulledClasses[subject]!.contains(number) {
                continue
            } else {
                Constants.pulledClasses[subject]?.append(number)
            }
        }
        //print("class List: ", Constants.pulledClasses)
        print("class list organized")
    }
    
    static func createCustomer() {
        let baseURL = URL(string: "https://fibonia-stripe-server.herokuapp.com/")! //for use in createPaymentIntent
        let url = baseURL.appendingPathComponent("create_customer")
        AF.request(url).responseJSON { (data) in
            switch data.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        currStripe = JSON["id"] as! String
                        print("custID", currStripe)
                }
            case .failure(let error):
                print("error: ", error)
            }
        }
    }

    func checkTime(time: String, timezone: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.timeZone = NSTimeZone(abbreviation: timezone) as TimeZone?
        let inputTime = formatter.date(from: time)
        
        let newTime = formatter.string(from: inputTime!)
        let GMTTime = Date()
        let currTime = formatter.string(from: GMTTime)
        
        //Incomplete function
        return false
    }
    
    static func getUTCTimeDifference() -> Int {
        let diffSeconds = TimeZone.current.secondsFromGMT()
        let rawMins = diffSeconds / 60
        let hours = (rawMins / 60) * 100
        let mins = rawMins % 60
        return hours + mins
    }
    
    static func convertTime(timeDifference: Int, time: Int) -> Int {
        var hrs = (time / 100) - (timeDifference / 100)
        var mins = 0
        if timeDifference < 0 {
            mins = (time % 100) + ((-1 * timeDifference) % 100)
        } else {
            mins = (time % 100) - (timeDifference % 100)
        }
        hrs += mins / 60
        hrs = modulus(number: hrs, divisor: 24)
        mins = modulus(number: mins, divisor: 60)
        let finalTime = (hrs * 100) + mins
        return finalTime
    }
    
    static func convertToLocalTime(timeDifference: Int, time: Int) -> Int {
        var hrs = (time / 100) + (timeDifference / 100)
        var mins = 0
        if timeDifference < 0 {
            mins = (time % 100) - ((-1 * timeDifference) % 100)
        } else {
            mins = (time % 100) + (timeDifference % 100)
        }
        hrs += mins / 60
        hrs = modulus(number: hrs, divisor: 24)
        mins = modulus(number: mins, divisor: 60)
        let finalTime = (hrs * 100) + mins
        return finalTime
    }
    
    static func modulus(number: Int, divisor: Int) -> Int {
        if number >= 0 {
            return number % divisor
        } else {
            let rem = number % divisor
            return rem + divisor
        }
    }
    
    static func next7Days() -> [String] {
        var result = [String]()
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d"
        
        for i in 1...7 {
            let newDate = Date(timeInterval: 60*60*24*Double(i), since: date)
            let curr = formatter.string(from: newDate)
            result.append(curr)
        }
        
        return result
    }
    
    static func createAlert(title: String, message: String, buttonMsg: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            viewController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    static func char50UID() -> String {
        let twent1 = UUID().uuidString.components(separatedBy: "-")
        let twent2 = UUID().uuidString.components(separatedBy: "-")
        let ten1 = UUID().uuidString.components(separatedBy: "-")
        return twent1[0] + twent1[4] + twent2[0] + twent2[4] + ten1[0] + "GK"
    }
    
    static func resetAll() {
        currName = "nope"
        currEmail = ""
        currTutorEmail = ""
        currStudent = Student(fn: "", ln: "", eml: "", appt: [["ABC":"DEF"]], subjects: [], stripeID: "", accntType: "", firstlogin: false)
        currTutor = Tutor(name: "", calEmail: "", gradyear: 0, subjects: [], zoom: "", setPrefs: false, preferences: ["languages": [], "location": []], img: "", firstlogin: false, prefTime: ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()], educationLevel: "", bio: "")
        defaultTutor = Tutor(name: "", calEmail: "", gradyear: 0, subjects: [], zoom: "", setPrefs: false, preferences: ["languages": [], "location": []], img: "", firstlogin: false, prefTime: ["0": [Int](), "1":[Int](), "2":[Int](), "3":[Int](), "4":[Int](), "5":[Int](), "6":[Int]()], educationLevel: "", bio: "")
        pickedClass = ""
        desperate = []
        alreadyEntered = false
        currStripe = ""
        tempSubjects = []
        studentUnconfirmedAppts = []
        studentConfirmedAppts = []
        tutorUnconfirmedAppts = []
        tutorConfirmedAppts = []
        
    }
        
}
