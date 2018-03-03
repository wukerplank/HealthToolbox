//
//  HomeNavigationController.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController, HomeCoordinator {

	var generateDataViewController: UIViewController!

	private lazy var homeViewController: UIViewController = {
		let controller = HomeViewController(coordinator: self)
		controller.title = "Health Tool Box"
		return controller
	}()

	init() {
		super.init(nibName: nil, bundle: nil)
		self.navigationBar.prefersLargeTitles = true
		self.viewControllers = [self.homeViewController]
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: HomeCoordinator

	func generateDataSelected() {
		self.pushViewController(self.generateDataViewController, animated: true)
	}
	
}
