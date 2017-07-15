//
//  BookHistoryModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 15/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

protocol BookHistoryModelProtocol: class {
	
	func itemsDownloaded(items: NSArray)
}

class BookHistoryModel: NSObject, URLSessionDelegate {

	var resourceID :  String?
	var startDateTime : String?
	var endDateTime : String?
	var status : String?
	weak var delegate: BookHistoryModelProtocol!
	let urlPath = "http://neoville.space/bookhistory.php"
	
	override init()
	{
		
	}
	
	
	init(resourceID: String, startDateTime: String, endDateTime: String, status: String) {
		
		self.resourceID = resourceID
		self.startDateTime = startDateTime
		self.endDateTime = endDateTime
		self.status = status
		
	}
	
	func downloadItems() {
		
		let url = URL(string: urlPath)!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let postString = "username=\(UserDefaults.standard.string(forKey: "currentUser")!)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			if error != nil {
				
				print("Failed to download data!")
			}
			else {
				
				self.parseJSON(data!)
			}
		})
		
		task.resume()
	}
	
	func parseJSON(_ data: Data) {
		
		var jsonResult = NSArray()
		
		do {
			
			jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
		}
		catch let error as NSError {
			
			print(error)
		}
		
		var jsonElement = NSDictionary()
		let histories = NSMutableArray()
		
		for i in 0 ..< jsonResult.count {
			
			jsonElement = jsonResult[i] as! NSDictionary
			let history = BookHistoryModel()
			
			history.resourceID = jsonElement["ResourceID"] as? String
			history.startDateTime = jsonElement["StartDateTime"] as? String
			history.endDateTime = jsonElement["EndDateTime"] as? String
			history.status = jsonElement["Status"] as? String
			
			histories.add(history)
		}
		
		DispatchQueue.main.async(execute: { () -> Void in
			
			self.delegate.itemsDownloaded(items: histories)
			
		})
	}
}
