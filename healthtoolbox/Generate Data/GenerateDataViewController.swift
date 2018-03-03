//
//  GenerateDataViewController.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import Eureka
import HealthKit
import MBProgressHUD

class GenerateDataViewController: FormViewController {

	private enum State {
		case initial
		case success(sampleCount: Int)
		case working
		case error(Error)
	}

	var dataGenerator: HealthKitDataGenerator!
	var healthStore: HKHealthStore!
	private var state: State = .initial {
		didSet {

			// Button status
			switch state {
			case .initial, .success(_), .error:
				self.generateButton.disabled = Condition.init(booleanLiteral: false)
				self.generateButton.evaluateDisabled()
			case .working:
				self.generateButton.disabled = Condition.init(booleanLiteral: true)
				self.generateButton.evaluateDisabled()
			}

			// Progress
			switch state {
			case .working:
				let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
				hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
			case .success(_), .error(_), .initial:
				MBProgressHUD.hide(for: self.view, animated: true)
			}

			// Other
			switch state {
			case .initial, .working:
				break
			case .success(let sampleCount):
				self.informUser(title: "Success", message: "Created \(sampleCount) samples in Health")
			case .error(let error):
				self.informUser(title: "Error", message: error.localizedDescription)
			}
		}
	}

	private lazy var startTimeRow = DateTimeRow { row in
		row.title = "Start time"
		row.value = Calendar.current.date(byAdding: .month, value: -1, to: Date())
	}

	private lazy var endTimeRow = DateTimeRow { row in
		row.title = "End time"
		row.value = Date()
	}

	private lazy var cgmSwitch = SwitchRow { row in
		row.title = "CGM"
		row.tag = "cgmSwitch"
		row.value = true
	}

	private lazy var cgmDevice = PushRow<CGMDevice> { row in
		row.title = "CGM device"
		row.hidden = "$cgmSwitch == false"
		row.options = CGMDevice.knownDevices
		row.value = CGMDevice.knownDevices.first
		row.displayValueFor = { value in
			return value?.name
		}
	}

	private lazy var carbsSwitch = SwitchRow { row in
		row.title = "Carbs"
		row.value = false
	}

	private lazy var stepsSwitch = SwitchRow { row in
		row.title = "Steps"
		row.value = false
	}

	private lazy var generateButton = ButtonRow { row in
		row.title = "Generate"
		row.onCellSelection { [weak self] _, _ in
			self?.startDataGeneration()
		}
	}

	private var configuration: GeneratorConfiguration {
		return GeneratorConfiguration(
			startDate: self.startTimeRow.value!,
			endDate: self.endTimeRow.value!,
			cgm: self.cgmSwitch.value!,
			cgmInterval: 300,
			cgmDevice: self.cgmDevice.value!,
			carbs: self.carbsSwitch.value!,
			steps: self.stepsSwitch.value!
		)
	}



	init() {
		super.init(nibName: nil, bundle: nil)
		self.title = "Generate data"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let timeRangeSection = Section("Timespan")
		timeRangeSection.append(contentsOf: [
			self.startTimeRow,
			self.endTimeRow,
		])
		self.form.append(timeRangeSection)

		let cgmSection = Section("CGM")
		cgmSection.append(contentsOf: [
			self.cgmSwitch,
			self.cgmDevice,
		])
		self.form.append(cgmSection)

		let dataTypesSection = Section("Data")
		dataTypesSection.append(contentsOf: [
			self.carbsSwitch,
			self.stepsSwitch,
		])
		self.form.append(dataTypesSection)

		let generateSection = Section()
		generateSection.append(contentsOf: [
			self.generateButton,
		])
		self.form.append(generateSection)
	}

	override func viewDidAppear(_ animated: Bool) {

		let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!

		self.healthStore.requestAuthorization(toShare: Set([bloodGlucoseType]), read: nil) { (success, error) in
			if let error = error {
				print("Error requesting user's consent: \(error)")
			}
		}
	}

	private func startDataGeneration() {

		self.state = .working

		self.dataGenerator.generateData(for: self.configuration, onError: { error in
			self.state = .error(error)
		}, onSuccess: { sampleCount in
			print("Successfully created \(sampleCount) measurements")
			self.state = .success(sampleCount: sampleCount)
		})
	}
}
