//
//  GeneratorConfiguration.swift
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

extension CGMDevice: Equatable {

	static func ==(lhs: CGMDevice, rhs: CGMDevice) -> Bool {
		return lhs.udiDeviceIdentifier == rhs.udiDeviceIdentifier
	}
}

extension CGMDevice {

	static let knownDevices = [
		CGMDevice(name: "Device 1", manufacturer: "tba", model: "tba", hardwareVersion: "tba", firmwareVersion: "tba", softwareVersion: "tba", localIdentifier: "tba", udiDeviceIdentifier: "355c3058-3ea7-44d1-a5d4-c8b8d10f1ac7"),
		CGMDevice(name: "Device 2", manufacturer: "tba", model: "tba", hardwareVersion: "tba", firmwareVersion: "tba", softwareVersion: "tba", localIdentifier: "tba", udiDeviceIdentifier: "6211d905-6ea2-4295-8d91-8a0f4af6fbec"),
		CGMDevice(name: "Device 3", manufacturer: "tba", model: "tba", hardwareVersion: "tba", firmwareVersion: "tba", softwareVersion: "tba", localIdentifier: "tba", udiDeviceIdentifier: "7bd0e045-5a05-4b94-a3b4-63cd6eb660b4"),
	]
}
