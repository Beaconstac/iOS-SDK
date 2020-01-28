//
//  Beacon.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 27/11/17.
//  Copyright © 2017 Amit Prabhu. All rights reserved.
//

import Foundation
import CoreBluetooth

/// Main Beacon class
@objc public class Beacon: NSObject {
    
    /// Beacon name as found in the CBPeriferal object
    @objc public let name: String?
    
    /// UUID identifier of the beacon
    @objc public let identifier: UUID
    
    /// BeaconID - unique for each beacon as per Eddystone RFC
    @objc public let beaconID: BeaconID
    
    /// Transmission power of the beacon
    @objc public let txPower: Int
    
    /// RSSI value of the beacon. Can be used to determine how far away the beacon is from the device
    @objc public var rssi: Int
    
    /// Timestamp when the device recieved a packet from the beacon.
    /// Can be any one of URL, UID/EID or the TLM frames
    @objc public var lastSeen: Date = Date()
    
    /// Eddystone URL being broadcasted by the beacon
    @objc public var eddystoneURL: URL?
    
    /// Filtered RSSI value based on the filter type specified
    @objc public var filteredRSSI: Int {
        get {
            return self.filter.filteredRSSI ?? 0
        }
    }
    
    /// Distance of the beacon from the device
    @objc public var distance: Double {
        get {
            if (txPower == 0 || rssi == 0) {
                return -1
            }
            var dist = -1.0
            if (rssi == 0) {
                return dist // if we cannot determine accuracy, return -1.
            }
            let ratio = Double(rssi) * 1.0 / Double(txPower)
            if (ratio < 1.0) {
                dist = pow(ratio, 10)
            } else {
                dist = (0.89976) * pow(ratio, 7.7095) + 0.111
            }
            return dist
        }
    }
    
    /// Telemtry data from the beacon. Always updated to the latest value
    @objc public var telemetry: Telemetry?
    
    /// Kalman filter
    private let filter: RSSIFilter
    
    private init(identifier: UUID,
                 beaconID: BeaconID,
                 txPower: Int,
                 rssi: Int,
                 name: String?,
                 filterType: RSSIFilterType) {
        self.name = name
        self.identifier = identifier
        self.beaconID = beaconID
        self.txPower = txPower
        self.rssi = rssi
        
        if filterType == .arma {
            self.filter = ArmaFilter()
        } else if filterType == .kalman {
            self.filter = KalmanFilter()
        } else if filterType == .gaussian {
            self.filter = GaussianFilter()
        } else {
            self.filter = RunningAverageFilter()
        }
        
        super.init()
    }
    
    /**
     Failable convinience initialiser to create a Beacon object with Eddystone UID/EID packet
     
     - Parameter frameData: The frameData.
     - Parameter telemetry: The telemetry data obtained from Beacon.telemetryDataForFrame. Optional.
     - Parameter rssi: The RSSI value of the beacon.
     */
    convenience internal init?(identifier: UUID,
                               frameData: Data?,
                               rssi: Int,
                               name: String?,
                               namespaceFilter: String?,
                               filterType: RSSIFilterType) {
        guard let frameData = frameData, frameData.count > 1 else {
            return nil
        }
        
        let frameBytes = Array(frameData) as [UInt8]
        
        let frameByte = frameBytes[0]
        guard (frameByte == Eddystone.EddystoneUIDFrameTypeID ||
            frameByte == Eddystone.EddystoneEIDFrameTypeID) else {
            debugPrint("Unexpected non UID/EID Frame passed to the initialiser.")
            return nil
        }
        
        let txPower = Int(Int8(bitPattern:frameBytes[1]))
        
        let beaconID: BeaconID
        if frameByte == Eddystone.EddystoneUIDFrameTypeID {
            guard frameBytes.count >= 18 else {
                debugPrint("Frame Data for UID Frame unexpectedly truncated.")
                return nil
            }
            beaconID = BeaconID(beaconType: .eddystone,
                                    beaconID: Array(frameBytes[2..<18]))
            if let filter = namespaceFilter {
                if let namespace = beaconID.namespace?.hexString {
                    if filter != namespace {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } else {
            guard frameBytes.count >= 10 else {
                debugPrint("Frame Data for EID Frame unexpectedly truncated.")
                return nil
            }
            beaconID = BeaconID(beaconType: .eddystoneEID,
                                    beaconID: Array(frameBytes[2..<10]))
        }
        
        self.init(identifier: identifier,
                  beaconID: beaconID,
                  txPower: txPower,
                  rssi: rssi,
                  name: name,
                  filterType: filterType)
    }
    
    /**
     Update the beacon object with changable data
     
     - Parameter telemetryData: Telemetry Data from the beacon.
     - Parameter eddystoneURL: The eddystoneURL of the beacon.
     - Parameter rssi: The current RSSI value of the beacon.
     */
    internal func updateBeacon(telemetryData: Data?, eddystoneURL: URL?, rssi: Int) {
        self.rssi = rssi
        self.filter.calculate(forRSSI: rssi)
        self.lastSeen = Date()
        
        if let eddystoneURL = eddystoneURL {
            self.eddystoneURL = eddystoneURL
        }
        
        guard let telemetryData = telemetryData else {
            return
        }
        
        // Check if the beacon already has a telemtry data object
        if let _ = self.telemetry {
            self.telemetry?.update(tlmFrameData: telemetryData)
        } else {
            // Create a new object
            self.telemetry = Telemetry(tlmFrameData: telemetryData)
        }
    }
}

extension Beacon {
    // MARK: CustomStringConvertible protocol requirements
    override public var description: String {
        return self.beaconID.description
    }
}

extension Beacon {
    // MARK: Equatable protocol requirements
    public static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.beaconID == rhs.beaconID
    }
}

extension Beacon {
    // MARK: Hashable protocol requirements
    override public var hash: Int {
        get {
            return self.description.hash
        }
    }
}

