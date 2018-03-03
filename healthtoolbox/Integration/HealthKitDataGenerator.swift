//
//  HealthKitDataGenerator.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import Foundation
import HealthKit

struct CGMDevice {
	let name: String?
	let manufacturer: String?
	let model: String?
	let hardwareVersion: String?
	let firmwareVersion: String?
	let softwareVersion: String?
	let localIdentifier: String? // e.g. Bluetooth device ID
	let udiDeviceIdentifier: String? // FDA identifier

	var healthKitDevice: HKDevice {
		return HKDevice(name: self.name, manufacturer: self.manufacturer, model: self.model, hardwareVersion: self.hardwareVersion, firmwareVersion: self.firmwareVersion, softwareVersion: self.softwareVersion, localIdentifier: self.localIdentifier, udiDeviceIdentifier: self.udiDeviceIdentifier)
	}
}

struct GeneratorConfiguration {
	let startDate: Date
	let endDate: Date
	let cgm: Bool
	let cgmInterval: TimeInterval
	let cgmDevice: CGMDevice

	let carbs: Bool
	let steps: Bool
}

class HealthKitDataGenerator {

	var healthStore: HKHealthStore!

	private lazy var mgDL: HKUnit = {
		return HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))
	}()

	func generateData(for configuration: GeneratorConfiguration) {

		var samples = [HKQuantitySample]()

		var nextDate = configuration.startDate
		while nextDate <= configuration.endDate {

			let value = self.bloodGlucoseValue(for: nextDate.timeIntervalSince(configuration.startDate))
			let bloodGlucoseQuantity = HKQuantity(unit: self.mgDL, doubleValue: value)
			let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
			let device = configuration.cgmDevice.healthKitDevice

			let bloodGlucoseSample = HKQuantitySample(
				type: bloodGlucoseType,
				quantity: bloodGlucoseQuantity,
				start: nextDate,
				end: nextDate,
				device: device,
				metadata: [:]
			)

			samples.append(bloodGlucoseSample)

			nextDate.addTimeInterval(configuration.cgmInterval)
		}

		self.healthStore.save(samples) { success, error in
			if success {
				print("Successfully created \(samples.count) measurements")
			}
			else if let error = error {
				print("Error creating samples: \(error)")
			}
		}
	}

	func bloodGlucoseValue(for time: TimeInterval) -> Double {

		let amplitude = 75.0
		let offset = 125.0
		let value = (sin(time / 43200) * amplitude) + offset

		return value
	}
}

