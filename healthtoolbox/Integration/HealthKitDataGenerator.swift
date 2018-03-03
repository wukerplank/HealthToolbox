//
//  HealthKitDataGenerator.swift
//  healthtoolbox
//
//  Created by Wukerplank on 03.03.18.
//  Copyright © 2018 Wukerplank. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitDataGenerator {

	var healthStore: HKHealthStore!

	private lazy var mgDL: HKUnit = {
		return HKUnit.gramUnit(with: .milli).unitDivided(by: HKUnit.literUnit(with: .deci))
	}()

	func generateData(for configuration: GeneratorConfiguration, onError: ((Error) -> Void)? = nil, onSuccess: ((Int) -> Void)? = nil) {

		var samples = [HKQuantitySample]()

		if configuration.cgm {
			samples += self.generateCGMData(for: configuration)
		}

		self.healthStore.save(samples) { success, error in
			if success {
				DispatchQueue.main.async {
					onSuccess?(samples.count)
				}
			}
			else if let error = error {
				DispatchQueue.main.async {
					onError?(error)
				}
			}
		}
	}

	private func generateCGMData(for configuration: GeneratorConfiguration) -> [HKQuantitySample] {
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

		return samples
	}

	private func bloodGlucoseValue(for time: TimeInterval) -> Double {

		let amplitude = 75.0
		let offset = 125.0
		let value = (sin(time / 43200) * amplitude) + offset

		return value
	}
}

