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
    
    /// Creates gradient view
    
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

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home entered")
        // Do any additional setup after loading the view.
        //authenticateUser()
        setUpElements()
        // Begin pull from BerkeleyTime
        Utils.fetchData(from: "https://www.berkeleytime.com/api/catalog/catalog_json/") { result in
        switch result {
        case .success(let _):
            //print("pull success")
            do {
                Constants.pulledOutput = try result.get()
                print("pull complete")
                print("length", Constants.pulledOutput.count)
            } catch {
                print("output not saved")
            }
        case .failure(let error):
            self.createAlert(title: "Error", message: error.localizedDescription + " Please try again later.", buttonMsg: "Okay")
            }
        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if Utils.Connection() == false {
            print("bad connection")
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
            
            var classList = [String]()
            
            do {
                let results = try context.fetch(request)
                for data in results as! [NSManagedObject] {
                    currName = data.value(forKey: "name") as! String
                    currEmail =  data.value(forKey: "email") as! String
                }
            } catch {
                print("data pull fail")
            }
            
            let tutrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TutorData")
            do {
                let results = try context.fetch(tutrequest)
                
                for data in results as! [NSManagedObject] {
                    currTutorEmail = data.value(forKey: "tutorEmail") as! String
                    classList.append(data.value(forKey: "classes") as! String)
                }
            } catch {
                print("data pull fail")
            }
            print(classList)
            print("entering bar sequence from VC")
            
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarCont)
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
            
        }
    }
    
    func setUpElements() {
        Utils.styleFilledButton(signUpButton)
        Utils.styleFilledButton(loginButton)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeScreenViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        } else {
            return 
        }
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




