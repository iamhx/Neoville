//
//  BookPeriodViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 14/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class BookPeriodViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var txtStartDateTime: UITextField!
	
	@IBOutlet weak var txtEndDateTime: UITextField!
	
	@IBAction func btnCheckAvailability(_ sender: UIButton) {
		
		
	}
	
	var resourceType : String?
	let startTimePicker = UIDatePicker()
	let endTimePicker = UIDatePicker()
	var startDate = Date()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		hideKeyboardWhenTappedAround()
		txtStartDateTime.delegate = self
		txtEndDateTime.delegate = self
		txtEndDateTime.isUserInteractionEnabled = false
		
		startTimePicker.datePickerMode = .dateAndTime
		startTimePicker.minuteInterval = 5
		txtStartDateTime.inputView = startTimePicker
		
		
		endTimePicker.datePickerMode = .dateAndTime
		endTimePicker.minuteInterval = 5
		txtEndDateTime.inputView = endTimePicker
		startTimePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
		endTimePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)

		self.title = resourceType
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		if (textField == txtStartDateTime) {
			
			startTimePicker.minimumDate = Date()
		}
		else if (textField == txtEndDateTime) {
			
			endTimePicker.minimumDate = startDate.addingTimeInterval(1800)
			endTimePicker.maximumDate = startDate.addingTimeInterval(10800)
		}
	}
	
	func startDateChanged() {
		
		if (!txtEndDateTime.isUserInteractionEnabled) {
			
			txtEndDateTime.isUserInteractionEnabled = true
		}
		else {
			
			txtEndDateTime.text = ""
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
		txtStartDateTime.text = dateFormatter.string(from: startTimePicker.date)
		startDate = dateFormatter.date(from: txtStartDateTime.text!)!
	}
	
	func endDateChanged() {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
		txtEndDateTime.text = dateFormatter.string(from: endTimePicker.date)
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
