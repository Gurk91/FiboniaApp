//
//  MenuCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setUp(Rimg: UIImage, txt: String, Limg: UIImage) {
        label.text = txt
        leftImage.image = Limg
        rightImage.image = Rimg
    }
    
}
