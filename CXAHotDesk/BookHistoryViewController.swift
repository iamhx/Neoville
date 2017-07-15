//
//  BookHistoryViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 15/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class historyCell : UITableViewCell {
	
	@IBOutlet weak var lblResourceID: UILabel!
	@IBOutlet weak var lblStartDateTime: UILabel!
	
	@IBOutlet weak var lblEndDateTime: UILabel!
	
	@IBOutlet weak var lblStatus: UILabel!
}

class BookHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookHistoryModelProtocol {

	@IBOutlet weak var historyTableView: UITableView!
	
	var feedItems: NSArray = NSArray()
	var histories = BookHistoryModel()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.historyTableView.delegate = self
		self.historyTableView.dataSource = self
		
		histories.delegate = self
		histories.downloadItems()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feedItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCellIdentifier") as! historyCell
		let item = feedItems[indexPath.row] as! BookHistoryModel
		
		cell.lblResourceID?.text = item.resourceID
		cell.lblStartDateTime.text = formatDate(string: item.startDateTime!)
		cell.lblEndDateTime.text = formatDate(string: item.endDateTime!)
		cell.lblStatus.text = item.status

		return cell
	}
	
	func formatDate(string: String) -> String {
		
		let parseDate = DateFormatter()
		parseDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = parseDate.date(from: string)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
		let newDate = dateFormatter.string(from: date!)
		
		return newDate
		
	}
	
	func itemsDownloaded(items: NSArray) {
		
		feedItems = items
		self.historyTableView.reloadData()
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
