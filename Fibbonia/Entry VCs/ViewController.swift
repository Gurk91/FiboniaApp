//
//  MainScreenViewController.swift
//  
//
//  Created by Gurkarn Goindi on 6/Mar/20.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import CoreData
import GoogleSignIn
import Firebase
import Network

class ViewController: UIViewController, CAAnimationDelegate {
    
    //ANIMATION CODE BEGINS
    
    let gradient = CAGradientLayer()
    
    // list of array holding 2 colors
    var gradientSet = [[CGColor]]()
    // current gradient index
    var currentGradient: Int = 0
    
    // colors to be added to the set
    let colorOne = #colorLiteral(red: 0, green: 0.1750556231, blue: 0.3745066226, alpha: 1).cgColor
    let colorTwo = #colorLiteral(red: 0.1254901961, green: 0.2784313725, blue: 0.4509803922, alpha: 1).cgColor
    let colorThree = #colorLiteral(red: 0.2509803922, green: 0.337254902, blue: 0.4352941176, alpha: 1).cgColor

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createGradientView()
    }
    
    // Creates gradient view
    
    func createGradientView() {
        
        // overlap the colors and make it 3 sets of colors
        gradientSet.append([colorOne, colorTwo])
        gradientSet.append([colorTwo, colorThree])
        gradientSet.append([colorThree, colorOne])
        //gradientSet.append([colorTwo, colorOne])
        
        // set the gradient size to be the entire screen
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    
    func animateGradient() {
        // cycle through all the colors, feel free to add more to the set
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        // animate over 3 seconds
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "gradientChangeAnimation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        // if our gradient animation ended animating, restart the animation by changing the color set
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
    //ANIMATION CODE OVER
    
    //MARK: Regular Ability begins

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //@IBOutlet weak var googleButton: GIDSignInButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var internetComs: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        print("home entered")

        setUpElements()
        
        // Begin pull from BerkeleyTime
                
    }
    
    override func viewDidLoad() {
        setUpElements()
        
        if (Auth.auth().currentUser != nil){
            self.showSpinner(onView: self.view)
            print("user signed in")
            let user = Auth.auth().currentUser
            let email = user?.email
            user?.reload(completion: { (error) in
                switch user!.isEmailVerified {
                case true:
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(email!)
                    docRef.getDocument { (document, error) in
                        // Check for error
                        if error == nil {
                            // Check that this document exists
                            if document != nil && document!.exists {
                                let documentData = document!.data()
                                print("************ PRINTING DOC VALS ************")
                                let name = documentData!["firstName"] as Any? as? String
                                let ln = documentData!["lastName"] as Any? as? String
                                let subjects = documentData!["subjects"] //as! [String]
                                currName = name! + " " + ln!
                                print(currName)
                                currEmail = email!
                                currStudent = Student(fn: name!, ln: ln!, eml: email!, appt: documentData!["appointments"] as! [[String : Any]], subjects: subjects as! [String], stripeID: documentData!["stripe_id"] as! String, accntType: documentData!["accntType"] as! String, firstlogin: false)
                                currStripe = currStudent.stripeID
                                currStudent.tutor = documentData!["tutor"] as! Bool
                                currStudent.calEmail = documentData!["calEmail"] as! String
                                
                                Utils.reloadAppointments()
                                
                                print("entering bar sequence")
                                
                                let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
                                self.view.window?.rootViewController = tabBarController
                                self.view.window?.makeKeyAndVisible()
                                
                            }
                        } else {
                            self.createAlert(title: "Error Logging In", message: error!.localizedDescription, buttonMsg: "Okay")
                            self.removeSpinner()
                            return
                        }
                    }
                case false:
                    return
                }
            })
        } else {
            return
        }
        
    }
    
    func setUpElements() {
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(loginButton)
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        sender.pulsate()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        (sender as! UIButton).pulsate()
    }
    
    
    func createAlert(title: String, message: String, buttonMsg: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMsg, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

