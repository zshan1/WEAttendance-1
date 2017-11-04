//
//  Tab.swift
//  iAttendance
//
//  Created by shan on 10/30/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class Tab: UITabBarController {
    
    
    
    override func viewDidLoad() {
        self.selectedIndex = 1;
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
