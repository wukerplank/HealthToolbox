//
//  UIAlertController+Additions.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import UIKit

extension UIViewController {

	func informUser(title: String, message: String) {

		let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { _ in
			controller.dismiss(animated: true, completion: nil)
		}
		controller.addAction(action)

		self.present(controller, animated: true)
	}
}
