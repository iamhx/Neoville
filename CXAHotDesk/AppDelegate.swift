//
//  AppDelegate.swift
//  CXAHotDesk
//
//  Created by Hongxuan on 4/7/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import SystemConfiguration

extension UIViewController {
	
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		//tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		
		view.endEditing(true)
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
}

protocol Utilities {
}

extension NSObject : Utilities{
	
	
	enum ReachabilityStatus {
		case notReachable
		case reachableViaWWAN
		case reachableViaWiFi
	}
	
	var currentReachabilityStatus : ReachabilityStatus {
		
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		}) else {
			return .notReachable
		}
		
		var flags: SCNetworkReachabilityFlags = []
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return .notReachable
		}
		
		if flags.contains(.reachable) == false {
			// The target host is not reachable.
			return .notReachable
		}
		else if flags.contains(.isWWAN) == true {
			// WWAN connections are OK if the calling application is using the CFNetwork APIs.
			return .reachableViaWWAN
		}
		else if flags.contains(.connectionRequired) == false {
			// If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
			return .reachableViaWiFi
		}
		else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
			// The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
			return .reachableViaWiFi
		}
		else {
			return .notReachable
		}
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

//	func setStatusBarBackgroundColor(color: UIColor) {
//		
//		guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//		
//		statusBar.backgroundColor = color
//	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
//		setStatusBarBackgroundColor(color: .white)
		if UserDefaults.standard.string(forKey: "currentUser") != nil {
			
			ContactModel().deleteContacts()
		}
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

	}


}

