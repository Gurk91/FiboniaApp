//
//  CurrentAppointmentViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 20/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import Stripe

class CurrentAppointmentViewController: UIViewController, SFSafariViewControllerDelegate, STPPaymentContextDelegate {
    

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var tutorName: UILabel!

    @IBOutlet weak var amountPayLabel: UILabel!
    @IBOutlet weak var tutorChargeLabel: UILabel!
    @IBOutlet weak var processingFeesLabel: UILabel!
    
    
    var currAppt: [String: Any] = ["":""]
    var price = ""
    var rating = ""
    
    var customerContext = STPCustomerContext(keyProvider: MyAPIClient())
    var paymentContext = STPPaymentContext()
    var baseURL = URL(string: "https://fibonia-stripe-server.herokuapp.com/")!
    var clientSecretFinal = ""
    var customerID = ""
    var tutorStripeID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currAppt = currentAppointment
        getTutorStuff()
        // Do any additional setup after loading the view.
        
        Utils.styleFilledGreenButton(payButton)
        Utils.styleHollowDeleteButton(cancelButton)
        //Stripe
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        enterParams()
    }
    
    //MARK: Visual and PaymentIntent Setup
    func enterParams() {
        let db = Firestore.firestore()
        db.collection(currAppt["classname"] as! String).document(currAppt["tutorEmail"] as! String).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an error loading the appointment details. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            }
            if document != nil && document!.exists {
                let documentData = document!.data()
                self.ratingLabel.text! = String(documentData!["rating"] as! Double)
                self.priceLabel.text! = documentData!["price"] as! String
            }
        }

        
        tutorName.text! = currAppt["tutorFN"] as! String
        notesLabel.text! = "Appointment Notes: " + (currAppt["notes"] as! String)
        classLabel.text! = currAppt["classname"] as! String
        
        let importedTime = currAppt["time"] as! String
        let timecomps = importedTime.components(separatedBy: " ")
        let date = timecomps[0] + " " + timecomps[1] + " " + timecomps[2]
        let timings = timecomps[3..<timecomps.count]
        var finalTimes = ""
        let timedifference = Utils.getUTCTimeDifference()
        for time in timings {
            let converted = Utils.convertToLocalTime(timeDifference: timedifference, time: Int(time)!)
            finalTimes = finalTimes + String(converted) + " "
        }
        timeLabel.text! = date + " " + finalTimes
        let tutAmount = timings.count * Int(price)!
        let procAmount = Double(tutAmount) * 0.1
        let totalAmount = Double(tutAmount) + procAmount
        amountPayLabel.text = "Total Amount: $" + String(totalAmount)
        tutorChargeLabel.text! = String(timings.count) + "hour appointment @ " + price + "/hr: $" + String(tutAmount)
        processingFeesLabel.text! = "Stripe Fees + Convenience Fee @ 10%: $" + String(procAmount)
        let params = ["amount": totalAmount, "customer": currStudent.stripeID, "tutorID": tutorStripeID] as [String : Any]
        self.createPaymentIntent(dict: params)
    }
    
    func getTutorStuff() {
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currAppt["tutorEmail"] as! String)
        docRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.tutorStripeID = documentData!["stripe_id"] as! String
                    self.rating = String(documentData!["rating"] as! Double)
                    self.price = documentData!["price"] as! String
                }
            } else {
                print("unknown error retriving data")
            }
        }

    }
    
    //MARK: Stripe Payment Stuff
    @IBAction func payPressed(_ sender: Any) {
        self.paymentContext.requestPayment()
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
        print("didchange")
        return
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecretFinal)
        paymentIntentParams.configure(with: paymentResult)
        paymentIntentParams.returnURL = "myStripeTest://payments-redirect"
        
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
            title = "Payment Successful!"
            message = "Your payment was successful! Happy Learning!"
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
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
    
    
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    
    //MARK: Zoom connectivity things
    @IBAction func zoomPressed(_ sender: Any) {
        guard let zoomurl = URL(string: currAppt["zoom"] as! String) else {
            Utils.createAlert(title: "Fault Zoom/ Online ID URL", message: "Please contact Fibonia Support and we shall resolve your situation as soon as possible", buttonMsg: "Okay", viewController: self)
            return
        }
        
        let safariViewController = SFSafariViewController(url: zoomurl)
        safariViewController.delegate = self

        present(safariViewController, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //MARK: Segue to rating appointment screen
        
        return
    }
    

}
