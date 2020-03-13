//
//  TabVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        
        guard let tabBar = self.tabBarController?.tabBar else {return}
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.mainGray()
        tabBar.unselectedItemTintColor = UIColor.mainGray()
        tabBar.backgroundColor = UIColor.mainGray()
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
