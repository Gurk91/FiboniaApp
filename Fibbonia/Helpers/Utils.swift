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
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.init(red: 0/255, green: 146/255, blue: 255/255, alpha: 1).cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.black
    }
    
    static func styleHollowDeleteButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.init(red: 247/255, green: 71/255, blue: 10/255, alpha: 1).cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.black
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
    
    
    
}
