//
//  StudentClassesCollectionViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 31/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class StudentClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    func setImg(img: String) {
        image.image = UIImage(named: img)
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
}
