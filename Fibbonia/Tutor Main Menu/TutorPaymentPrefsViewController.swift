//
//  TutorPaymentPrefsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import SwiftyJSON
import Firebase

class TutorPaymentPrefsViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
        
        if currTutor.stripe_id != "" {
            stripeButton.setTitle("Go to Stripe Dashboard", for: .normal)
        }
        
        Utils.styleFilledButton(stripeButton)
        Utils.styleFilledButton(venmoButton)
        
        let url = Constants.emailServerURL.appendingPathComponent("access-express/\(currTutor.stripe_id)")
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            self.reply = String(data: data, encoding: .utf8)!
        }
        task.resume()
    }
    
    let clientID: String = "ca_HN6e9WbJXmHgEeo7I3pIeEaTsX8aKN6A"
    let state: String = "234162eb-b627-4899-b123-5dda1859a631"
    var reply: String = ""
    
    @IBOutlet weak var stripeButton: UIButton!
    @IBOutlet weak var venmoButton: UIButton!
    
    
    @IBAction func didSelectConnectWithStripe(_ sender: Any) {
        if currTutor.stripe_id != "" {
            
            /*
            let parameters = ["stripe":currTutor.stripe_id]
            let headers = HTTPHeader(name: "Content-Type", value: "application/json")
            let heads = HTTPHeaders([headers])
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: heads)
                    .responseJSON { response in
                        print(response.result)
                        let reply = JSON(response.result)
                        print(reply)
                }
             */
            let goToURL = URL(string: reply)!
            let safariViewController = SFSafariViewController(url: goToURL)
            safariViewController.delegate = self

            present(safariViewController, animated: true, completion: nil)

        } else {
            // Construct authorization URL
            guard let authorizationURL = URL(string: "https://connect.stripe.com/express/oauth/authorize?client_id=\(clientID)&state=\(state)&stripe_user[email]=\(currTutor.calEmail)&redirect_uri=https://fibonia-stripe-server.herokuapp.com/connect/oauth") else {
                return
            }

            let safariViewController = SFSafariViewController(url: authorizationURL)
            safariViewController.delegate = self

            present(safariViewController, animated: true, completion: nil)
        }
        
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("back from Safari")
        let db = Firestore.firestore()
        db.collection("users").document(currTutor.calEmail).getDocument { (document, error) in
            if error != nil {
                Utils.createAlert(title: "Error", message: "There was an unknown error. Please try again", buttonMsg: "Okay", viewController: self)
                print(error.debugDescription)
            } else {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    currTutor.stripe_id = documentData!["stripe_id"] as! String
                }
            }
        }
    }
    
    
    
}
