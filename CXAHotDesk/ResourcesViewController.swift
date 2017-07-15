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
	
	@IBOutlet weak var lblResourceID: UILabel!
	@IBOutlet weak var lblTimerDescription: UILabel!
	@IBOutlet weak var outletEndSession: UIButton!
	
	
	@IBAction func btnEndSession(_ sender: UIButton) {
	}
	
	@IBOutlet weak var resourcesTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let username = UserDefaults.standard.string(forKey: "currentUser")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let currentDate = dateFormatter.string(from: Date())
		
		self.resourcesTableView.delegate = self
		self.resourcesTableView.dataSource = self
		
		resources.delegate = self
		resources.downloadItems()
		CheckBookedModel().checkBooked(user: username!, currentDateTime: currentDate, VC: self)
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
			
			let alert = UIAlertController(title: "Unable to book resource", message: "You can only book one resource at a time. Please cancel the session if you wish to book another resource.", preferredStyle: .alert)
			
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			
			alert.addAction(okAction)
			self.present(alert, animated: true, completion: nil)
		}
		else {

			let item = feedItems[indexPath.row] as! ResourceTypeModel
			resourceType = item.resourceType
			self.performSegue(withIdentifier: "showBookPeriod", sender: self)
			resourcesTableView.deselectRow(at: indexPath, animated: true)
		}
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
	

}
