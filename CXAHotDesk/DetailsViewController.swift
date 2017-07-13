//
//  DetailsViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 13/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
	
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblEmail: UILabel!
	@IBOutlet weak var lblDOB: UILabel!
	@IBOutlet weak var lblRole: UILabel!
	@IBOutlet weak var lblID: UILabel!
	
	let firstName : String = UserDefaults.standard.string(forKey: "userFirstName")!
	let lastName : String = UserDefaults.standard.string(forKey: "userLastName")!
	let email : String = UserDefaults.standard.string(forKey: "userEmail")!
	let dateOfBirth : String = UserDefaults.standard.string(forKey: "userDOB")!
	let role : String = UserDefaults.standard.string(forKey: "userRole")!
	let id : String = UserDefaults.standard.string(forKey: "currentUser")!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		let formattedDate = dateFormatter.string(from: convertDate())
		
		lblName.text = "\(firstName) \(lastName)"
		lblEmail.text = email
		lblDOB.text = formattedDate
		lblRole.text = role
		lblID.text = id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func convertDate() -> Date {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = dateFormatter.date(from: dateOfBirth)
		
		return date!
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
