//
//  ContactModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 12/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class ContactModel: NSObject {
	
	func requestDetails(user: String) {
		
		let url = URL(string: "http://neoville.space/contact.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				print("No data found")
				return
			}
			
			do {
				
				if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
					
					let jsonElement : NSDictionary = jsonResult[0] as! NSDictionary
					let email = jsonElement["Email"]!
					let firstName = jsonElement["FirstName"]!
					let lastName = jsonElement["LastName"]!
					let dateOfBirth = jsonElement["DateOfBirth"]!
					let role = jsonElement["Role"]!
					
					self.setContacts(email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, role: role)
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
	
	func setContacts(email: Any, firstName: Any, lastName: Any, dateOfBirth: Any, role: Any) {
		
		UserDefaults.standard.set(email, forKey: "userEmail")
		UserDefaults.standard.set(firstName, forKey: "userFirstName")
		UserDefaults.standard.set(lastName, forKey: "userLastName")
		UserDefaults.standard.set(dateOfBirth, forKey: "userDOB")
		UserDefaults.standard.set(role, forKey: "userRole")
	}
	
	func deleteContacts() {
		
		UserDefaults.standard.removeObject(forKey: "currentUser")
		UserDefaults.standard.removeObject(forKey: "userEmail")
		UserDefaults.standard.removeObject(forKey: "userFirstName")
		UserDefaults.standard.removeObject(forKey: "userLastName")
		UserDefaults.standard.removeObject(forKey: "userDOB")
		UserDefaults.standard.removeObject(forKey: "userRole")
	}
}
