//
//  TabBarController.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 27/Mar/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    static private(set) var currentInstance: TabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    
}


