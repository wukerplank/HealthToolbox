//
//  AppDelegate.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import HealthKit
import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	let container: Container = {
		let container = Container()
		container.register(HKHealthStore.self) { _ in HKHealthStore() }

		container.register(HealthKitDataGenerator.self) { r in
			let generator = HealthKitDataGenerator()
			generator.healthStore = r.resolve(HKHealthStore.self)
			return generator
		}

		container.register(GenerateDataViewController.self) { r in
			let controller = GenerateDataViewController()
			controller.healthStore = r.resolve(HKHealthStore.self)
			controller.dataGenerator = r.resolve(HealthKitDataGenerator.self)
			return controller
		}

		container.register(HomeNavigationController.self) { r in
			let controller = HomeNavigationController()
			controller.generateDataViewController = r.resolve(GenerateDataViewController.self)
			return controller
		}

		return container
	}()

	private var healthStore = HKHealthStore()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		let navbarBackground = UIColor(red: 1.0, green: 0.83, blue: 0.42, alpha: 1.00)
		let navbarTint = UIColor(red: 0.98, green: 0.42, blue: 0.40, alpha: 1.00)

		UINavigationBar.appearance().tintColor = navbarTint
		UINavigationBar.appearance().barTintColor = navbarBackground
		if #available(iOS 11.0, *) {
			UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: navbarTint]
		}
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: navbarTint]

		let rootViewController = container.resolve(HomeNavigationController.self)

		window = UIWindow.init(frame: UIScreen.main.bounds)
		window?.rootViewController = rootViewController
		window?.makeKeyAndVisible()

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

