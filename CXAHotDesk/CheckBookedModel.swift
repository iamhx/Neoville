//
//  CheckBookedModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 15/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class CheckBookedModel: NSObject {
	
	
	func checkBooked(user: String, currentDateTime: String, VC: ResourcesViewController) {
		
		let url = URL(string: "http://neoville.space/checkcurrentlybooked.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)&currentDateTime=\(currentDateTime)"
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
						
						self.populateDetails(user: user, currentDateTime: currentDateTime, VC: VC, bool: 1)
					}
					else {
						
						self.populateDetails(user: user, currentDateTime: currentDateTime, VC: VC, bool: 0)
					}
				}
				else {
					
					print("Could not parse JSON")
				}
			}
			catch {
				
				print("Request failed")
			}
		})
		
		task.resume()
	}
	
	func convertDate(date: String) -> Date {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = dateFormatter.date(from: date)
		
		return date!
	}
	
	func populateDetails(user: String, currentDateTime: String, VC: ResourcesViewController, bool: Int) {
		
		let url = URL(string: "http://neoville.space/populatedetails.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)&currentDateTime=\(currentDateTime)&success=\(bool)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				print("No data found")
				return
			}
			
			do {
				
				if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
					
					let jsonElement : NSDictionary = jsonResult[0] as! NSDictionary
					
					
					if (bool == 1) {
						
						DispatchQueue.main.async {
							
							VC.outletEndSession.isHidden = false
							VC.lblResourceID.isHidden = false
							VC.lblTimerDescription.isHidden = false
							
							VC.lblResourceID.text = jsonElement["ResourceID"]! as? String
							VC.outletEndSession.setTitle("End Session", for: .normal)
							VC.lblTimerDescription.text = "Timer Start"
							
						}
						
						VC.booked = true
					}
					else if (bool == 0) {
							
						
						if let _ = jsonElement["notBooked"] as? Bool, true {
								
								DispatchQueue.main.async {
									
									VC.lblTimerDescription.isHidden = false
									VC.outletEndSession.isHidden = true
									VC.lblResourceID.isHidden = true
									
									VC.lblTimerDescription.text = "You do not have any booked resources."
									
									VC.booked = false
							}
						}
						else {
							
							let dateFormatter = DateFormatter()
							dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
							
							let formattedStartDate = dateFormatter.string(from: self.convertDate(date: (jsonElement["StartDateTime"]! as? String)!))
							let formattedEndDate = dateFormatter.string(from: self.convertDate(date: (jsonElement["EndDateTime"]! as? String)!))
							
							
							DispatchQueue.main.async {
								
								VC.outletEndSession.isHidden = false
								VC.lblResourceID.isHidden = false
								VC.lblTimerDescription.isHidden = false
								VC.lblResourceID.text = jsonElement["ResourceID"]! as? String
								VC.lblTimerDescription.text = "\(formattedStartDate) - \(formattedEndDate)"
								VC.outletEndSession.setTitle("Cancel Session", for: .normal)
							}
							
							VC.booked = true
						}
					}
				}
				else {
					
					print("Could not parse JSON!")
				}
				
				if (VC.presentedViewController != nil) {
					
					DispatchQueue.main.async {
						
						VC.dismiss(animated: false, completion: nil)
					}
				}
			}
			catch {
				
				print("Request failed!")
			}
		})
		
		task.resume()
	}
}
