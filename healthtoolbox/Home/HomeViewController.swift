//
//  HomeViewController.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import Eureka

protocol HomeCoordinator {
	func generateDataSelected()
}

class HomeViewController: FormViewController {

	private lazy var generateDataButton = ButtonRow { row in
		row.title = "Generate data"
		row.onCellSelection { [weak self] _, _ in
			self?.coordinator?.generateDataSelected()
		}
	}

	private var coordinator: HomeCoordinator?

	init(coordinator: HomeCoordinator) {
		self.coordinator = coordinator

		super.init(nibName: nil, bundle: nil)
		self.title = "Home"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let section = Section()
		section.append(contentsOf: [
			self.generateDataButton
		])
		self.form.append(section)
	}

}
