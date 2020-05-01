//
//  StudentNewAppointmentViewController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 30/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit
import Firebase

class StudentNewAppointmentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var output : [Constants.tutorField] = []
    
    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var classPicker: UIPickerView!
    
    @IBOutlet weak var findTutorbutton: UIButton!

    private var subjects: [String] = [String]()
    private var classes: [String] = [String]()
    
    var selectedSubject: String = ""
    var selectedClass: String = ""
    
    var data = [Constants.tutorField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.styleFilledButton(findTutorbutton)

        // Do any additional setup after loading the view.
        subjects = Constants.subjects
        classes = Constants.emptyList
        self.classPicker.delegate = self
        self.classPicker.delegate = self
        self.subjectPicker.delegate = self
        self.subjectPicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return subjects.count
        } else {
            return classes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return subjects[row]
        } else {
            return classes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedSubject = subjects[row]
            classes = Utils.getClasses(subject: selectedSubject)
            classPicker.selectRow(0, inComponent: 0, animated: true)
            self.classPicker.reloadAllComponents()
        } else {
            selectedClass = classes[row]
        }
        
    }
    
    @IBAction func findPressed(_ sender: Any) {
        desperate = Constants.classTutors[selectedClass]!
        pickedClass = selectedClass
    }
    
    

}
