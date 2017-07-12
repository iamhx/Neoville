//
//  ContactModel.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 12/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

protocol ContactModelProtocol : class {
	
	func itemsDownloaded(items: NSArray)
}

class ContactModel: NSObject, URLSessionDelegate {

	weak var delegate: ContactModelProtocol!
	var data = Data()
	
	//Properties
	
	var email: String?
	var firstName : String?
	var lastName : String?
	var dateOfBirth : String?
	var role : String?
	
	//empty constructor
	
	override init()
	{
		
	}
	
	//construct with @email, @firstName, @lastName, @dateOfBirth and @role parameters
	
	init(email: String, firstName: String, lastName: String, dateOfBirth: String, role: String) {
		
		self.email = email
		self.firstName = firstName
		self.lastName = lastName
		self.dateOfBirth = dateOfBirth
		self.role = role
	}
}
