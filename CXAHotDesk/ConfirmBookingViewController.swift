//
//  ConfirmBookingViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 15/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class ConfirmBookingViewController: UIViewController {

	var selectedID : String?
	var startDate : Date?
	var endDate : Date?
	
	@IBOutlet weak var lblSelectedResource: UILabel!
	
	@IBOutlet weak var lblStartDateTime: UILabel!
	
	@IBOutlet weak var lblEndDateTime: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
		
		let parsedStartDate = dateFormatter.string(from: startDate!)
		let parsedEndDate = dateFormatter.string(from: endDate!)
		
		lblSelectedResource.text = selectedID
		lblStartDateTime.text = parsedStartDate
		lblEndDateTime.text = parsedEndDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func btnConfirm(_ sender: UIButton) {
		
		showOverlayOnTask(message: "Please wait...")
		
		let username = UserDefaults.standard.string(forKey: "currentUser")
		
		BookResourceModel().bookResource(user: username!, resourceID: selectedID!, startDateTime: startDate!, endDateTime: endDate!, VC: self)
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
