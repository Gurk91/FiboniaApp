//
//  Menu2TableViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 28/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class Menu2TableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    func setUp(txt: String) {
        label.text = txt
    }
    
}
