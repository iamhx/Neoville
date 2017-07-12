//
//  LoginViewController.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 5/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var txtUsername: UITextField!
	
	@IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		hideKeyboardWhenTappedAround()
		
//		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
        // Do any additional setup after loading the view.
    }
	
//	override func viewDidDisappear(_ animated: Bool) {
//		super.viewDidDisappear(animated)
//		
//		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
//		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
//	}

	@IBAction func btnLogin(_ sender: UIButton) {
		
		if (currentReachabilityStatus == .notReachable) {
			
			promptMessage(message: "An internet connection is required to log in.")
		}
		else if (txtUsername.text!.isEmpty || txtPassword.text!.isEmpty) {
			
			promptMessage(message: "One or more required fields is missing. Please try again.")
		}
		else {
			
			showOverlayOnTask(message: "Logging in...")
			requestLogin()
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func requestLogin() {
		
		let url = URL(string: "http://neoville.space/login.php")
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		let postString = "username=\(txtUsername.text!)&password=\(txtPassword.text!)"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			
			guard data != nil else {
				
				self.promptMessage(message: "No data found")
				return
			}
			
			do {
				
				if let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
					
					let success = jsonData.value(forKey: "success") as! Bool
					
					if (success) {
						
						DispatchQueue.main.async {
							
							self.dismiss(animated: false, completion: { action in
								
								UserDefaults.standard.set(self.txtUsername.text!, forKey: "currentSession")
								
								let storyboard = UIStoryboard(name: "Main", bundle: nil)
								let mainMenuVC = storyboard.instantiateViewController(withIdentifier: "MainMenuID") as! UITabBarController
								self.present(mainMenuVC, animated: true, completion: nil)
							})
							return
						}
					}
					else {
						
						DispatchQueue.main.async {
							
							self.dismiss(animated: false, completion: { action in
								
								self.promptMessage(message: "The username or password that you have entered is incorrect. Please try again.")}
							)
						}
						return
					}
				}
				else {
					
					DispatchQueue.main.async {
						
						self.dismiss(animated: false, completion: { action in
							
							self.promptMessage(message: "Error: Could not parse JSON!")
						})
					}
				}
			}
			catch {
				
				DispatchQueue.main.async {
					
					self.dismiss(animated: false, completion: { action in
						
						self.promptMessage(message: "Error: Request failed!")
					})
				}
			}
		})
		
		task.resume()
	}
	
	func promptMessage(message: String) {
		
		let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func showOverlayOnTask(message: String) {
		
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		
		let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating();
		
		alert.view.addSubview(loadingIndicator)
		self.present(alert, animated: true, completion: nil)
	}
	
//	func keyboardWillShow(sender: NSNotification) {
//		
//		let userInfo = sender.userInfo!
//		
//		let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
//		let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
//		
//		if keyboardSize.height == offset.height {
//			
//			if self.view.frame.origin.y == 0 {
//				
//				UIView.animate(withDuration: 0.1, animations: { () -> Void in
//					self.view.frame.origin.y -= keyboardSize.height
//				})
//			}
//		}
//		else
//		{
//			
//			UIView.animate(withDuration: 0.1, animations: { () -> Void in
//				self.view.frame.origin.y += keyboardSize.height - offset.height
//			})
//		}
//	}
//	
//	func keyboardWillHide(sender: NSNotification) {
//		
//		let userInfo  = sender.userInfo!
//		let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
//		self.view.frame.origin.y += keyboardSize.height
//	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

