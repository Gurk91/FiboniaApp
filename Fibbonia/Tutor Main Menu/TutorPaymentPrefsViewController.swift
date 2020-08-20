//
//  TutorPaymentPrefsViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/Jul/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import SafariServices

class TutorPaymentPrefsViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let clientID: String = "ca_HN6e9WbJXmHgEeo7I3pIeEaTsX8aKN6A"
    let state: String = "234162eb-b627-4899-b123-5dda1859a631"
    
    @IBOutlet weak var stripeButton: UIButton!
    
    
    @IBAction func didSelectConnectWithStripe(_ sender: Any) {
        //let redirect = "https://fibonia-stripe-server.herokuapp.com/connect/oauth"
        print("https://connect.stripe.com/express/oauth/authorize?client_id=\(clientID)&state=\(state)&stripe_user[email]=\(currTutor.calEmail)&redirect_uri=https://fibonia-stripe-server.herokuapp.com/connect/oauth")
        
        // Construct authorization URL
        guard let authorizationURL = URL(string: "https://connect.stripe.com/express/oauth/authorize?client_id=\(clientID)&state=\(state)&stripe_user[email]=\(currTutor.calEmail)&redirect_uri=https://fibonia-stripe-server.herokuapp.com/connect/oauth") else {
            return
        }

        let safariViewController = SFSafariViewController(url: authorizationURL)
        safariViewController.delegate = self

        present(safariViewController, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("back from Safari")
    }
    
}
