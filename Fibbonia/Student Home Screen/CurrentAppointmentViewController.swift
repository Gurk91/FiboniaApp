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
    var price = 0
    var rating = ""
    
    var customerContext = STPCustomerContext(keyProvider: MyAPIClient())
    var paymentContext = STPPaymentContext()
    var baseURL = URL(string: "https://fibonia-stripe-server.herokuapp.com/")!
    var clientSecretFinal = ""
    var customerID = ""
    var tutorStripeID = ""
    var tutorvenmoID = ""
    var tutorVenmoBal = 0.0
    var tutorAppts: [[String: Any]] = []
    var tutorClasses = [""]
    var pars: [String: Any] = ["":""]
    var stripeMoney = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTutorStuff()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
        
        Utils.styleFilledGreenButton(payButton)
        Utils.styleHollowDeleteButton(cancelButton)
        //Stripe
        let db = Firestore.firestore()
        let docRef = db.collection("tutors").document(currAppt["tutorEmail"] as! String)
        docRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.tutorStripeID = documentData!["stripe_id"] as! String
                    self.rating = String(documentData!["rating"] as! Double)
                    self.tutorAppts = documentData!["appointments"] as! [[String: Any]]
                    self.tutorClasses = documentData!["classes"] as! [String]
                    self.tutorvenmoID = documentData!["venmo_id"] as! String
                    self.tutorVenmoBal = documentData!["venmo_balance"] as! Double
                    self.customerContext = STPCustomerContext(keyProvider: MyAPIClient())
                    self.paymentContext = STPPaymentContext(customerContext: self.customerContext)
                    self.paymentContext.delegate = self
                    self.paymentContext.hostViewController = self
                    self.enterParams()
                }
            } else {
                print("unknown error retriving data 1")
            }
        }
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
                self.priceLabel.text! = String(documentData!["price"] as! Int)
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
    }
    
    func getTutorStuff() {
        let db = Firestore.firestore()
        let docRef2 = db.collection(currAppt["classname"] as! String).document(currAppt["tutorEmail"] as! String)
        docRef2.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.price = documentData!["price"] as! Int
                    let importedTime = self.currAppt["time"] as! String
                    let timecomps = importedTime.components(separatedBy: " ")
                    let timings = timecomps[3..<timecomps.count]
                    let tutAmount = timings.count * self.price
                    self.stripeMoney = Double(tutAmount)
                    var procAmount = 0.0
                    if self.currAppt["group_tutoring"] as! Bool == true {
                        procAmount = Double(tutAmount) * 0.05 + 0.3
                    } else {
                        procAmount = Double(tutAmount) * 0.09 + 0.3
                    }
                    
                    let totalAmount = Double(tutAmount) + procAmount
                    self.amountPayLabel.text = "Total Amount: $" + String(totalAmount)
                    self.tutorChargeLabel.text! = String(timings.count) + "hour appointment @ " + String(self.price) + "/hr: $" + String(tutAmount)
                    self.processingFeesLabel.text! = "Processing Fees @ 10%: $" + String(procAmount)
                    
                    if self.tutorStripeID == "" {
                        self.pars = ["amount": totalAmount * 100, "customer": currStudent.stripeID] as [String : Any]
                    } else {
                        self.pars = ["amount": totalAmount * 100, "customer": currStudent.stripeID, "tutorID": self.tutorStripeID] as [String : Any]
                    }
                    
                    print(self.pars)
                    
                }
            } else {
                print("unknown error retriving data 2")
            }
        }
        

    }
    
    //MARK: Stripe Payment Stuff
    @IBAction func payPressed(_ sender: Any) {
        print("tutor", self.tutorStripeID)
        self.createPaymentIntent(dict: self.pars)
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
        paymentIntentParams.returnURL = "myFibonia://payments-redirect"
        
        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
            switch status {
            case .succeeded:
                print("success")
                if self.tutorStripeID == "" {
                    self.tutorVenmoBal += self.stripeMoney
                }
                self.currAppt["txn_id"] = paymentIntent!.stripeId
                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(currStudent.email)
                var newStudentAppts = self.removeAppointment(array: currStudent.appointments, appt: self.currAppt)
                newStudentAppts.append(self.currAppt)
                docRef.setData(["appointments": newStudentAppts], merge: true)
                currStudent.appointments = newStudentAppts
                
                let docRef2 = db.collection("tutors").document(self.currAppt["tutorEmail"] as! String)
                var newTutorAppts = self.removeAppointment(array: self.tutorAppts, appt: self.currAppt)
                newTutorAppts.append(self.currAppt)
                docRef2.setData(["appointments": newTutorAppts, "venmo_balance": self.tutorVenmoBal], merge: true)
                
                for clas in self.tutorClasses {
                    let docRef3 = db.collection(clas).document(self.currAppt["tutorEmail"] as! String)
                    docRef3.setData(["appointments": newTutorAppts], merge: true)
                }
                
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
            self.payButton.isHidden = true
            self.cancelButton.isHidden = true
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
    
    func removeAppointment(array: [[String: Any]], appt: [String: Any]) -> [[String: Any]] {
        var input = array
        for i in 0..<input.count {
            if appt["uid"] as! String == input[i]["uid"] as! String {
                input.remove(at: i)
                print("removed")
                print(input.count)
                break
            }
        }
        return input
    }
    

}
