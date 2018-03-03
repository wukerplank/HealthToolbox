//
//  GenerateDataViewController.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import Eureka
import HealthKit

class GenerateDataViewController: FormViewController {

	var dataGenerator: HealthKitDataGenerator!
	var healthStore: HKHealthStore!

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
		row.value = true
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

	private var cgmDevice: CGMDevice {
		return CGMDevice(
			name: "Health Kit Toolbox",
			manufacturer: "Wukerplank",
			model: "MARK I",
			hardwareVersion: "0.1",
			firmwareVersion: "0.1",
			softwareVersion: "0.1",
			localIdentifier: "ab0d94b5-5e53-4d88-9596-f7625c34ea1f",
			udiDeviceIdentifier: "018ed618-5ecb-40db-ad9e-7ae7fbd8fbbe"
		)
	}

	private var configuration: GeneratorConfiguration {
		return GeneratorConfiguration(
			startDate: self.startTimeRow.value!,
			endDate: self.endTimeRow.value!,
			cgm: self.cgmSwitch.value!,
			cgmInterval: 300,
			cgmDevice: self.cgmDevice,
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

		let dataTypesSection = Section("Data")
		dataTypesSection.append(contentsOf: [
			self.cgmSwitch,
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
		self.dataGenerator.generateData(for: self.configuration)
	}
}
