//
//  StudentLangViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 16/Jun/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentLangViewController: UIViewController {
    
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var mandarinButton: UIButton!
    @IBOutlet weak var hindiButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var malayButton: UIButton!
    @IBOutlet weak var russianButton: UIButton!
    @IBOutlet weak var frenchButton: UIButton!
    @IBOutlet weak var portugButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        langs = currStudent.preferences["languages"] as! String
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUp()
        langs = currStudent.preferences["languages"] as! String
    }
    
    var langs = currStudent.preferences["languages"] as! String
    var selected = ""
    var prefs = currStudent.preferences
    
    
    @IBAction func resetPressed(_ sender: Any) {
        langs = ""
        currStudent.preferences["languages"] = ""
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = ""
        docRef.setData(["preferences": prefs], merge: true)
        setUp()
    }
    
    @IBAction func engPressed(_ sender: Any) {
        print("none")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "English"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "English"
        currStudent.preferences["languages"] = "English"
        setUp()
        
    }
    
    @IBAction func cnyPressed(_ sender: Any) {
        print("none")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Mandarin"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Mandarin"
        currStudent.preferences["languages"] = "Mandarin"
        setUp()
    }
    
    @IBAction func hinPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Hindi"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Hindi"
        currStudent.preferences["languages"] = "Hindi"
        setUp()
    }
    
    @IBAction func spaPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Spanish"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Spanish"
        currStudent.preferences["languages"] = "Spanish"
        setUp()
    }
    
    @IBAction func araPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Arabic"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Arabic"
        currStudent.preferences["languages"] = "Arabic"
        setUp()
    }
    
    @IBAction func porPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Portuguese"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Portuguese"
        currStudent.preferences["languages"] = "Portuguese"
        setUp()
    }
    
    @IBAction func rusPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Russian"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Russian"
        currStudent.preferences["languages"] = "Russian"
        setUp()
    }
    
    @IBAction func frePressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "French"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "French"
        currStudent.preferences["languages"] = "French"
        setUp()
    }
    
    @IBAction func malPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currEmail)
        prefs["languages"] = "Malay"
        docRef.setData(["preferences": prefs], merge: true)
        langs = "Malay"
        currStudent.preferences["languages"] = "Malay"
        setUp()
    }
    
    
    func setUp() {
        colorButton1(englishButton)
        colorButton2(mandarinButton)
        colorButton3(hindiButton)
        colorButton4(spanishButton)
        colorButton5(arabicButton)
        colorButton6(malayButton)
        colorButton7(russianButton)
        colorButton8(frenchButton)
        colorButton9(portugButton)
        
        Utils.styleHollowDeleteButton(resetButton)
        
        if langs == "English" {
            englishButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Mandarin"  {
            mandarinButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Hindi" {
            hindiButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Spanish" {
            spanishButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Arabic" {
            arabicButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Portuguese" {
            portugButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Russian" {
            russianButton.backgroundColor = UIColor.darkGray
        }
        if langs == "French" {
            frenchButton.backgroundColor = UIColor.darkGray
        }
        if langs == "Malay" {
            malayButton.backgroundColor = UIColor.darkGray
        }
        
    }
    
    func colorButton1(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 247/255, green: 71/255, blue: 10/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton2(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 247/255, green: 190/255, blue: 10/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton3(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 186/255, green: 247/255, blue: 10/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton4(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 10/255, green: 186/255, blue: 247/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton5(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 10/255, green: 127/255, blue: 247/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton6(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 4/255, green: 66/255, blue: 93/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton7(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 247/255, green: 233/255, blue: 10/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton8(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 10/255, green: 247/255, blue: 115/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func colorButton9(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 247/255, green: 10/255, blue: 142/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(UIColor.white, for: .normal)
    }

}
