//
//  TutorSelectionTableViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 30/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class TutorSelectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var newTutorLabel: UILabel!
    
    func setVals(input: Constants.tutorField) {
        newTutorLabel.alpha = 0
        nameLabel.text! = input.name
        if Double(input.rating) == 0 {
            ratingLabel.text! = input.rating
            newTutorLabel.alpha = 1
        } else{
            ratingLabel.text! = input.rating
        }
        priceLabel.text! = "$" + input.price + " /hr"
    }
    

}
