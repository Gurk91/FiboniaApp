//
//  MyAPIClient.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 10/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation
import Stripe
import Alamofire


class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    var baseURL = URL(string: "https://fibonia-stripe-server.herokuapp.com/")!
    static let sharedClient = MyAPIClient()

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
        let params = ["customerID": currStripe]
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, error)
                return
            }
            completion(json, nil)
        })
        task.resume()
    }
        
}
