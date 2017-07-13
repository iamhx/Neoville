//
//  LoginModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 12/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class LoginModel: NSObject {
	
	func requestLogin(user: String, pass: String, VC: LoginViewController) {
		
		let url = URL(string: "http://neoville.space/login.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)&password=\(pass)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				VC.promptMessage(message: "No data found")
				return
			}
			
			do {
				
				if let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					
					let success = jsonData.value(forKey: "success") as! Bool
					
					if (success) {
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								UserDefaults.standard.set(user, forKey: "currentUser")
								ContactModel().requestDetails(user: user)
								
								let storyboard = UIStoryboard(name: "Main", bundle: nil)
								let mainMenuVC = storyboard.instantiateViewController(withIdentifier: "MainMenuID") as! UITabBarController
								VC.present(mainMenuVC, animated: true, completion: nil)
							})
						}
						
						return
					}
					else {
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								VC.promptMessage(message: "The username or password that you have entered is incorrect. Please try again.")
							})
						}
						return
					}
				}
				else {
					
					DispatchQueue.main.async {
						
						VC.dismiss(animated: false, completion: { action in
							
							VC.promptMessage(message: "Error: Could not parse JSON!")
						})
					}
				}
			}
			catch {
				
				DispatchQueue.main.async {
					
					VC.dismiss(animated: false, completion: { action in
						
						VC.promptMessage(message: "Error: Request failed!")
					})
				}
			}
		})
		
		task.resume()
	}
}
