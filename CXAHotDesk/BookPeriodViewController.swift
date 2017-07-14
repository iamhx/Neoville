//
//  BookPeriodViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 14/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class availResourceCell : UITableViewCell {
	
	@IBOutlet weak var lblResourceID: UILabel!
	
}

class BookPeriodViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var availResourcesTableView: UITableView!
	
	@IBOutlet weak var lblAvailResources: UILabel!
	
	@IBOutlet weak var txtStartDateTime: UITextField!
	
	@IBOutlet weak var txtEndDateTime: UITextField!
	
	@IBAction func btnCheckAvailability(_ sender: UIButton) {
		
		if ((txtStartDateTime.text?.isEmpty)! || (txtEndDateTime.text?.isEmpty)!) {
			
			let alert = UIAlertController(title: "Error", message: "One or more required fields is missing. Please check again.", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
		else {
			
			txtStartDateTime.resignFirstResponder()
			txtEndDateTime.resignFirstResponder()
			showOverlayOnTask(message: "Please wait...")
			
			let dateFormatter = DateFormatter()
			let timeFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			timeFormatter.dateFormat = "HH:mm:ss"
			let date = dateFormatter.string(from: startDate)
			let time = timeFormatter.string(from: startDate)
			CheckAvailableModel().checkAvailable(resourceType: resourceType!, startDate: date, startTime: time, VC: self)
			
			if (resourceIDs.count > 0) {
				
				DispatchQueue.main.async {
					
					self.dismiss(animated: false, completion: { action in
						
						self.lblAvailResources.isHidden = false
						self.availResourcesTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
					})
				}
			}
			else {
				
				DispatchQueue.main.async {
					
					self.dismiss(animated: false, completion: { action in
						
						print("No available resources")
					})
				}
			}

		}
	}
	
	var resourceType : String?
	let startTimePicker = UIDatePicker()
	let endTimePicker = UIDatePicker()
	var startDate = Date()
	var resourceIDs = NSArray()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		hideKeyboardWhenTappedAround()
		
		availResourcesTableView.delegate = self
		availResourcesTableView.dataSource = self
		
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of feed items
		
		return resourceIDs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = availResourcesTableView.dequeueReusableCell(withIdentifier: "availResourceCell") as! availResourceCell
		
		cell.lblResourceID?.text = resourceIDs[indexPath.row] as? String
		return cell
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
