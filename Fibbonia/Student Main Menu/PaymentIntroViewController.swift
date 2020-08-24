//
//  PaymentIntroViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 9/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class PaymentIntroViewController: UIViewController, STPPaymentContextDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(cardsButton)
        // Do any additional setup after loading the view.
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        //paymentContext.paymentAmount = 3000
        
        //self.createPaymentIntent(dict: dict)
        //createCustomer()
    }
    
    var customerContext = STPCustomerContext(keyProvider: MyAPIClient())
    var paymentContext = STPPaymentContext()
    var backendURL = ""
    var baseURL = URL(string: "https://fibonia-stripe-server.herokuapp.com/")! //for use in createPaymentIntent
    var clientSecretFinal = ""
    var customerID = ""
    
    @IBOutlet weak var cardsButton: UIButton!
    
    func createPaymentIntent(dict: [String:Any]) {
        print("create intent")
        let url = self.baseURL.appendingPathComponent("create-payment-intent")
        let params = dict
        let jsondata = try? JSONSerialization.data(withJSONObject: params)
        var clientSecretOut = ""
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
          guard let response = response as? HTTPURLResponse,
            response.statusCode == 200,
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let clientSecret = json["clientSecret"] as? String else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                print("Error: ", message)
                return
          }
            print("Created PaymentIntent")
            clientSecretOut = clientSecret
            print("client out inside: ", clientSecretOut)
            self?.clientSecretFinal = clientSecret
        })
        task.resume()
        //return clientSecretOut
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("context did change")
        return
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecretFinal)
        paymentIntentParams.configure(with: paymentResult)
        paymentIntentParams.returnURL = "myFibonia://payments-redirect"
        
        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
            switch status {
            case .succeeded:
                print("success")
                completion(.success, nil)
            case .failed:
                print("cant", error!)
                completion(.error, error)
            case .canceled:
                completion(.userCancellation, nil)
            @unknown default:
                completion(.error, nil)
            }
        }

    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Your purchase was successful!"
        case .userCancellation:
            return()
        @unknown default:
            return()
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func editCardsPressed(_ sender: Any) {
        self.paymentContext.presentPaymentOptionsViewController()
    }
    
}
