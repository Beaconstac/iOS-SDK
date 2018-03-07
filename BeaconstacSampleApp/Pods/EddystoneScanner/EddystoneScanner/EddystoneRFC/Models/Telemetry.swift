//
//  Telemetry.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 14/01/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// Struct that handles the beacon telemtry data
/// Specs https://github.com/google/eddystone/blob/master/eddystone-tlm/tlm-plain.md
///
@objc public class Telemetry: NSObject {
    
    /// Telemetry data version
    @objc public let version: String
    
    /// Battery voltage is the current battery charge in millivolts
    @objc public var voltage: UInt = 0
    
    /// Beacon temperature is the temperature in degrees Celsius sensed by the beacon. If not supported the value will be -128.
    @objc public var temperature: Float = 0
    
    /// ADV_CNT is the running count of advertisement frames of all types emitted by the beacon since power-up or reboot, useful for monitoring performance metrics that scale per broadcast frame
    @objc public var advCount: UInt = 0
    
    /// SEC_CNT is a 0.1 second resolution counter that represents time since beacon power-up or reboot
    @objc public var uptime: Float = 0
    
    /// Calculates the advertising interval of the beacon in milliseconds
    /// Assumes the beacon is transmitting all 3 eddystone packets (UID, URL and TLM frames)
    @objc public var advInt: Float {
        guard uptime != 0, uptime != 0 else {
                return 0
        }
        
        let numberOFFramesPerBeacon = 3
        return Float(numberOFFramesPerBeacon * 1000) / (Float(advCount) / uptime)
    }
    
    /// Battery percentage
    /// Assume the chip requires a 3V battery. Most of the beacons have Nordic chips which support 3V
    /// We aaume here that the lower bound is 2000 and upper bound is 3000
    /// If the milliVolt is less than 2000, we assume 0% and if it is greater than 3000 we consider it as 100% charged.
    /// The formula is % = (read milliVolt - LowerBound) / (UpperBound - LowerBound) * 100
    @objc public var batteryPercentage: UInt {
        guard voltage > 2000 else {
            return 0
        }
        
        guard voltage < 3000 else {
            return 100
        }
        
        let percentage: UInt = UInt(((Float(voltage) - 2000.0) / 1000.0) * 100.0)
        return percentage > 100 ? 100 : percentage
    }
    
    internal init?(tlmFrameData: Data) {
        guard let frameBytes = Telemetry.validateTLMFrameData(tlmFrameData: tlmFrameData) else {
            debugPrint("Failed to iniatialize the telemtry object")
            return nil
        }
        
        self.version = String(format: "%02X", frameBytes[1])
        super.init()
        
        self.parseTLMFrameData(frameBytes: frameBytes)
    }
    
    /**
     Update the telemetry object for the new telemtry frame data
     
     - Parameter tlmFrameData: The raw TLM frame data
     */
    internal func update(tlmFrameData: Data) {
        guard let frameBytes = Telemetry.validateTLMFrameData(tlmFrameData: tlmFrameData) else {
            debugPrint("Failed to update telemetry data")
            return
        }
        self.parseTLMFrameData(frameBytes: frameBytes)
    }
    
    /**
     Validate the TLM frame data
     
     - Parameter tlmFrameData: The raw TLM frame data
     */
    private static func validateTLMFrameData(tlmFrameData: Data) -> [UInt8]? {
        let frameBytes = Array(tlmFrameData) as [UInt8]
        
        // The length of the frame should be 14
        guard frameBytes.count == 14 else {
            debugPrint("Corrupted telemetry frame")
            return nil
        }
        return frameBytes
    }
    
    /**
     Parse the TLM frame data
     
     - Parameter frameBytes: The `UInt8` byte array
     */
    private func parseTLMFrameData(frameBytes: [UInt8]) {
        self.voltage = bytesToUInt(byteArray: frameBytes[2..<4])!
        self.temperature = Float(frameBytes[4]) + Float(frameBytes[5])/256
        self.advCount = bytesToUInt(byteArray: frameBytes[6..<10])!
        self.uptime = Float(bytesToUInt(byteArray: frameBytes[10..<14])!) / 10.0
    }
}
