//
//  LoginViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 5/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var txtUsername: UITextField!
	
	@IBOutlet weak var txtPassword: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func btnLogin(_ sender: UIButton) {
		
		let url = URL(string: "http://neoville.space/login.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(txtUsername.text!)&password=\(txtPassword.text!)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				print("No data found")
				return
			}
			
			do {
				
				if let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					
					let success = jsonData.value(forKey: "success") as! Bool
					
					if (success) {
						
						self.promptMessage(message: "login succeeded")
						UserDefaults.standard.set(self.txtUsername.text!, forKey: "currentSession")

						return
					}
					else {
						
						self.promptMessage(message: "login failed")
						return
					}
				}
				else {
					
					print("Could not parse JSON!")
				}
			}
			catch {
				
				print("Request failed")
			}
		})
		
		task.resume()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func promptMessage(message: String) {
		
		let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .default) { action in
			
		}
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
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
