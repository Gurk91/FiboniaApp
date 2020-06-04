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
    @IBOutlet weak var imageContainer: UIView!
    
    
    func setImg(img: String) {
        image.backgroundColor = UIColor.white
        image.image = UIImage(named: img)
        image.layer.borderWidth = 0
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.size.width / 2
        imageContainer.backgroundColor = UIColor.white
        imageContainer.layer.borderColor = UIColor.gray.cgColor
        imageContainer.layer.masksToBounds = false
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.cornerRadius = imageContainer.frame.size.width / 2
        imageContainer.clipsToBounds = true
        
        
    }
    
}
