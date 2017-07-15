//
//  ResourcesViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 13/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class ResourceTypeItem : UITableViewCell {
	
	@IBOutlet weak var lblResourceType: UILabel!
}

class ResourcesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ResourceTypeModelProtocol {

	var feedItems: NSArray = NSArray()
	var resources = ResourceTypeModel()
	var resourceType : String?
	var booked : Bool = false
	let username = UserDefaults.standard.string(forKey: "currentUser")
	var timer : Timer?
	var durationInSeconds : Int?
	
	@IBOutlet weak var lblResourceID: UILabel!
	@IBOutlet weak var lblTimerDescription: UILabel!
	@IBOutlet weak var outletEndSession: UIButton!
	
	
	@IBAction func btnEndSession(_ sender: UIButton) {
		
		if (outletEndSession.titleLabel?.text == "Cancel Session") {
			
			let alert = UIAlertController(title: "Confirm", message: "Do you wish to cancel your session?", preferredStyle: .alert)
			
			let yesAction = UIAlertAction(title: "Cancel Session", style: .destructive, handler: { action in
			
				self.timer?.invalidate()
				self.showOverlayOnTask(message: "Please wait...")
				self.updateEndDateTime(user: self.username!, endDateTime: self.getCurrentDate(), completedOrCancelled: "Cancelled")
			})
			
			let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			alert.addAction(yesAction)
			alert.addAction(noAction)
			self.present(alert, animated: true, completion: nil)
		}
		else if (outletEndSession.titleLabel?.text == "End Session") {
			
			let alert = UIAlertController(title: "Confirm", message: "Do you wish to end your session?", preferredStyle: .alert)
			
			let yesAction = UIAlertAction(title: "End Session", style: .destructive, handler: { action in
				
				self.timer?.invalidate()
				self.showOverlayOnTask(message: "Please wait...")
				self.updateEndDateTime(user: self.username!, endDateTime: self.getCurrentDate(), completedOrCancelled: "Completed")
			})
			
			let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			alert.addAction(yesAction)
			alert.addAction(noAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func updateEndDateTime(user: String, endDateTime: String, completedOrCancelled: String) {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let parsedEndDate : String = dateFormatter.string(from: Date())
		
		let url = URL(string: "http://neoville.space/updatebooking.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(user)&endDateTime=\(parsedEndDate)&completedOrCancelled=\(completedOrCancelled)"
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
						
						
						DispatchQueue.main.async {
							
							self.dismiss(animated: false, completion: { action in
								
								self.promptMessage(user: user)
							})
						}
						
						return
					}
					else {
						
						DispatchQueue.main.async {
							
							print("Could not end/cancel session!")
						}
						return
					}
				}
				else {
					
					DispatchQueue.main.async {
						
						self.dismiss(animated: false, completion: { action in
							
							print("Error: Could not parse JSON!")
						})
					}
				}
			}
			catch {
				
				DispatchQueue.main.async {
					
					self.dismiss(animated: false, completion: { action in
						
						print("Error: Request failed!")
					})
				}
			}
		})
		
		task.resume()
	}
	
	func promptMessage(user: String) {
	
		let alert = UIAlertController(title: "Success", message: "Successfully cancelled/ended resource.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
		
			CheckBookedModel().checkBooked(user: user, currentDateTime: self.getCurrentDate(), VC: self)
		})
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}

	
	
	@IBOutlet weak var resourcesTableView: UITableView!
	
	func getCurrentDate() -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let currentDate = dateFormatter.string(from: Date())
		
		return currentDate
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		
		self.resourcesTableView.delegate = self
		self.resourcesTableView.dataSource = self
		
		resources.delegate = self
		resources.downloadItems()
		
		let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDetails))
		
		self.navigationItem.rightBarButtonItem = refreshItem
		
		CheckBookedModel().checkBooked(user: username!, currentDateTime: getCurrentDate(), VC: self)
    }
	
	func refreshDetails() {
		
		timer?.invalidate()
		showOverlayOnTask(message: "Refreshing...")
		CheckBookedModel().checkBooked(user: username!, currentDateTime: getCurrentDate(), VC: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func itemsDownloaded(items: NSArray) {
		
		feedItems = items
		self.resourcesTableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of feed items
		return feedItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = resourcesTableView.dequeueReusableCell(withIdentifier: "ResourceTypeCell") as! ResourceTypeItem
		let item = feedItems[indexPath.row] as! ResourceTypeModel
		
		cell.lblResourceType?.text = item.resourceType

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		if (self.booked == true) {
			
			let alert = UIAlertController(title: "You can only book one resource at a time", message: "Please cancel or end the session if you wish to book another resource.", preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
		else {

			let item = feedItems[indexPath.row] as! ResourceTypeModel
			resourceType = item.resourceType
			self.performSegue(withIdentifier: "showBookPeriod", sender: self)
		}
		resourcesTableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: .UIApplicationDidEnterBackground, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "showBookPeriod") {
		
			let destination = segue.destination as! BookPeriodViewController
			destination.resourceType = resourceType
		}
    }
	
	func pauseTimer() {
		
		timer?.invalidate()
	}
	
	func resumeTimer() {
		
		showOverlayOnTask(message: "Refreshing...")
		CheckBookedModel().checkBooked(user: username!, currentDateTime: getCurrentDate(), VC: self)
	}
	
	func timerTickStart() {
		
		durationInSeconds = durationInSeconds! - 1
		self.lblTimerDescription.text = formattedTime(totalSeconds: durationInSeconds!)
		
		if (durationInSeconds! <= 0) {
			
			timer?.invalidate()
			
		}
		
	}
	
	func formattedTime(totalSeconds: Int) -> String {
		
		let seconds : Int = durationInSeconds! % 60;
		let minutes : Int = (durationInSeconds! / 60) % 60;
		let hours : Int = durationInSeconds! / 3600;
		
		return String.init(format: "%02d:%02d:%02d", hours, minutes, seconds);
	}

}
