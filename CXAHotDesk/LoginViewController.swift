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
		
		
		if (txtUsername.text!.isEmpty || txtPassword.text!.isEmpty) {
			
			promptMessage(message: "One or more required fields is missing. Please try again.")
		}
		else {
			
			showOverlayOnTask(message: "Logging in...")
			
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
							
							self.dismiss(animated: false, completion: nil)
							UserDefaults.standard.set(self.txtUsername.text!, forKey: "currentSession")
							
							let storyboard = UIStoryboard(name: "Main", bundle: nil)
							let mainMenuVC = storyboard.instantiateViewController(withIdentifier: "MainMenuID") as! UITabBarController
							self.present(mainMenuVC, animated: true, completion: nil)
							return
						}
						else {
							
							self.dismiss(animated: false, completion: nil)
							self.promptMessage(message: "The username or password that you have entered is incorrect. Please try again.")
							return
						}
					}
					else {
						
						self.dismiss(animated: false, completion: nil)
						self.promptMessage(message: "Error: Could not parse JSON!")
					}
				}
				catch {
					
					self.dismiss(animated: false, completion: nil)
					self.promptMessage(message: "Error: Request failed!")
				}
			})
			
			task.resume()
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func promptMessage(message: String) {
		
		let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .default) { action in
			
		}
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func showOverlayOnTask(message: String) {
		
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		
		let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating();
		
		alert.view.addSubview(loadingIndicator)
		present(alert, animated: true, completion: nil)
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
