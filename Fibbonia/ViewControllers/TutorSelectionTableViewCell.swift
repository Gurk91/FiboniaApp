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
    
    func setVals(input: Constants.tutorField) {
        nameLabel.text! = input.name
        if Double(input.rating) == 0 {
            ratingLabel.text! = "Rating: " + input.rating + (" (New Tutor)")
        } else{
            ratingLabel.text! = "Rating: " + input.rating
        }
        priceLabel.text! = "Price ($/hr): " + input.price
    }

}
