//
//  CheckAvailableModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 14/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//


import UIKit

class CheckAvailableModel: NSObject {
	
	func checkAvailable(resourceType: String, startDateTime: String, endDateTime: String, VC: BookPeriodViewController) {
		
		let url = URL(string: "http://neoville.space/checkavailable.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "resourceType=\(resourceType)&startDateTime=\(startDateTime)&endDateTime=\(endDateTime)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				print("No data found")
				return
			}
			
			do {
				
				if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
					
					let resourceIDs = NSMutableArray()
					var result = NSArray()

					for i in 0 ..< jsonResult.count {
						
						let jsonElement : NSDictionary = jsonResult[i] as! NSDictionary
						
						let resourceID = jsonElement["ResourceID"]!
						
						resourceIDs.add(resourceID)
					}
					
					result = resourceIDs
					VC.resourceIDs = result
					
					if (VC.resourceIDs.count > 0) {
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								VC.availResourcesTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
							})
						}
					}
					else {
						
						DispatchQueue.main.async {
							
							VC.dismiss(animated: false, completion: { action in
								
								// no avail resources
							})
						}
					}
				}
				else {
					
					print("Could not parse JSON!")
				}
			}
			catch {
				
				print("Request failed!")
			}
		})
		
		task.resume()
	}
}
