//
//  MainMenuController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 11/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class MainMenuController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
		if (tabBarController.selectedIndex == 2) {
			
			if let vc = viewController as? UINavigationController {
				vc.popViewController(animated: false)
			}
		}
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
