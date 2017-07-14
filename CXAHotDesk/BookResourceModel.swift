//
//  BookResourceModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 15/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class BookResourceModel: NSObject {

	
	func bookResource(user: String, resourceID: String, startDateTime: Date, endDateTime: Date, VC: ConfirmBookingViewController) {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let parsedStartDate : String = dateFormatter.string(from: startDateTime)
		let parsedEndDate : String = dateFormatter.string(from: endDateTime)
		
		let url = URL(string: "http://neoville.space/bookresource.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)&resourceID=\(resourceID)&startDateTime=\(parsedStartDate)&endDateTime=\(parsedEndDate)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				self.promptMessage(message: "No data found", VC: VC)
				return
			}
			
			do {
				
				if let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					
					let success = jsonData.value(forKey: "success") as! Bool
					
					if (success) {
						
						ContactModel().requestDetails(user: user)
						UserDefaults.standard.set(user, forKey: "currentUser")
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								self.returnToMainMenu(VC: VC, resourceID: resourceID)
							})
						}
						
						return
					}
					else {
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								self.promptMessage(message: "The username or password that you have entered is incorrect. Please try again.", VC: VC)
							})
						}
						return
					}
				}
				else {
					
					DispatchQueue.main.async {
						
						VC.dismiss(animated: false, completion: { action in
							
							self.promptMessage(message: "Error: Could not parse JSON!", VC: VC)
						})
					}
				}
			}
			catch {
				
				DispatchQueue.main.async {
					
					VC.dismiss(animated: false, completion: { action in
						
						self.promptMessage(message: "Error: Request failed!", VC: VC)
					})
				}
			}
		})
		
		task.resume()
	}
	
	func promptMessage(message: String, VC: ConfirmBookingViewController) {
		
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alert.addAction(okAction)
		VC.present(alert, animated: true, completion: nil)
	}
	
	func returnToMainMenu(VC: ConfirmBookingViewController, resourceID: String) {
		
		let alert = UIAlertController(title: "Success", message: "\(resourceID) is successfully booked.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let mainMenuVC = storyboard.instantiateViewController(withIdentifier: "MainMenuID") as! UITabBarController
			VC.present(mainMenuVC, animated: true, completion: nil)
		})
		
		alert.addAction(okAction)
		VC.present(alert, animated: true, completion: nil)
	}
}
