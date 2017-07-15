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

	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		hideKeyboardWhenTappedAround()
		
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
	}

	@IBAction func btnLogin(_ sender: UIButton) {
		
		if (currentReachabilityStatus == .notReachable) {
			
			promptMessage(message: "An internet connection is required to log in.")
		}
		else if (txtUsername.text!.isEmpty || txtPassword.text!.isEmpty) {
			
			promptMessage(message: "One or more required fields is missing. Please try again.")
		}
		else {
			
			txtUsername.resignFirstResponder()
			txtPassword.resignFirstResponder()
			showOverlayOnTask(message: "Logging in...")
			LoginModel().requestLogin(user: txtUsername.text!, pass: txtPassword.text!, VC: self)
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func promptMessage(message: String) {
		
		let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func keyboardWillShow(sender: NSNotification) {
		
		let userInfo = sender.userInfo!
		
		let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
		let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
		
		if keyboardSize.height == offset.height {
			
			if self.view.frame.origin.y == 0 {
				
				UIView.animate(withDuration: 0.1, animations: { () -> Void in
					self.view.frame.origin.y -= keyboardSize.height
				})
			}
		}
		else
		{
			
			UIView.animate(withDuration: 0.1, animations: { () -> Void in
				self.view.frame.origin.y += keyboardSize.height - offset.height
			})
		}
	}
	
	func keyboardWillHide(sender: NSNotification) {
		
		let userInfo  = sender.userInfo!
		let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
		self.view.frame.origin.y += keyboardSize.height
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

