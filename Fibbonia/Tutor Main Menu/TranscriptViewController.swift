//
//  TranscriptViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 19/Aug/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import SafariServices

class TranscriptViewController: UIViewController, SFSafariViewControllerDelegate {
    
    
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utils.styleFilledButton(uploadButton)
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        guard let authorizationURL = URL(string: "https://www.work.fibonia.com/transcript.php?code=5ef2ef87ae3e85ef2ef87ae4265ef2ef87ae4605ef2ef87ae499&email=\(currTutor.calEmail)") else {
            return
        }

        let safariViewController = SFSafariViewController(url: authorizationURL)
        safariViewController.delegate = self

        present(safariViewController, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        Utils.createAlert(title: "Thanks!", message: "Thanks for uploading your transcript. We'll get back to you within 24-48 hours on any classes you have signed up for.", buttonMsg: "Okay", viewController: self)
       }
    
}
