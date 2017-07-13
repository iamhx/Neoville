//
//  ResourceTypeModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 13/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

protocol ResourceTypeModelProtocol: class {
	
	func itemsDownloaded(items: NSArray)
}

class ResourceTypeModel: NSObject, URLSessionDelegate {

	
	var resourceType :  String?
	weak var delegate: ResourceTypeModelProtocol!
	let urlPath = "http://neoville.space/resourcetype.php"
	
	override init()
	{
		
	}
	
	
	init(resourceType: String) {
		
		self.resourceType = resourceType
		
	}
	
	func downloadItems() {
		
		let url = URL(string: urlPath)!
		let defaultSession = URLSession(configuration: .default)
		let task = defaultSession.dataTask(with: url) { data, response, error in
			
			if error != nil {
				
				print("Failed to download data!")
			}
			else {
				
				self.parseJSON(data!)
			}
		}
		
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
		let resourceTypes = NSMutableArray()
		
		for i in 0 ..< jsonResult.count {
			
			jsonElement = jsonResult[i] as! NSDictionary
			let resource = ResourceTypeModel()
			
			if let resourceType = jsonElement["ResourceType"] as? String {
				
				resource.resourceType = resourceType
			}
			
			resourceTypes.add(resource)
		}
	
		DispatchQueue.main.async(execute: { () -> Void in
			
			self.delegate.itemsDownloaded(items: resourceTypes)
			
		})
	}
}
