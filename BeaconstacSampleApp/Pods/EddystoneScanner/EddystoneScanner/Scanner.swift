//
//  Scanner.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 27/11/17.
//  Copyright © 2017 Amit Prabhu. All rights reserved.
//

import CoreBluetooth

@objc public enum State: Int {
    case unknown
    case off
    case on
}

///
/// ScannerDelegate
///
/// Implement this to receive notifications about beacons discovered in proximity.
@objc public protocol ScannerDelegate {
    @objc func didFindBeacon(scanner: Scanner, beacon: Beacon)
    @objc func didLoseBeacon(scanner: Scanner, beacon: Beacon)
    @objc func didUpdateBeacon(scanner: Scanner, beacon: Beacon)
    @objc func didUpdateScannerState(scanner: Scanner, state: State)
}

///
/// Scanner
///
/// Scans for Eddystone compliant beacons using Core Bluetooth. To receive notifications of any
/// sighted beacons, be sure to implement BeaconScannerDelegate and set that on the scanner.
///
@objc public class Scanner: NSObject {
    
    /// Scanner Delegate
    @objc public var delegate: ScannerDelegate?
    
    /// Namespace Filter
    @objc public var namespaceFilter: String? = nil
    
    /// Beacons that are close to the device.
    /// Keeps getting updated. Beacons are removed periodically when no packets are recieved in a 10 second interval
    public var nearbyBeacons = SafeSet<Beacon>(identifier: "nearbyBeacons")
    
    /// RSSI Filter type used
    @objc public let rssiFilterType: RSSIFilterType
    
    private var centralManager: CBCentralManager!
    private let beaconOperationsQueue: DispatchQueue = DispatchQueue(label: Constants.BEACON_OPERATION_QUEUE_LABEL)
    private var shouldBeScanning: Bool = false
    
    /// Timer to remove beacons not in the the apps proximity
    private var timer: DispatchTimer?
    
    private var state: State = .unknown {
        willSet {
            delegate?.didUpdateScannerState(scanner: self, state: newValue)
        }
    }
    
    // MARK: Public functions
    /// Initialises the CBCentralManager for scanning and the DispatchTimer
    public init(rssiFilterType: RSSIFilterType = .arma) {
        self.rssiFilterType = rssiFilterType
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: self.beaconOperationsQueue)
        self.timer = DispatchTimer(repeatingInterval: 10.0, queueLabel: Constants.DISPATCH_TIMER_QUEUE_LABEL)
        self.timer?.delegate = self
    }
    
    ///
    /// Start scanning. If Core Bluetooth isn't ready for us just yet, then waits and THEN starts scanning
    ///
    @objc public func startScanning() {
        guard centralManager.state == .poweredOn else {
            state = .off
            shouldBeScanning = true
            debugPrint("CentralManager state is %d, cannot start scan", centralManager.state.rawValue)
            return
        }
        if !shouldBeScanning {
            shouldBeScanning = true
            state = .on
            startScanningSynchronized()
            timer?.startTimer()
        }
    }
    
    ///
    /// Stops scanning for beacons
    ///
    @objc public func stopScanning() {
        if shouldBeScanning {
            shouldBeScanning = false
            centralManager.stopScan()
            timer?.stopTimer()
            DispatchQueue.main.async {
                for beacon in self.nearbyBeacons.getSet() {
                    self.delegate?.didLoseBeacon(scanner: self, beacon: beacon)
                }
                self.nearbyBeacons.removeAll()
            }
        }
    }
    
    
    // MARK: Private functions
    ///
    /// Starts scanning for beacons
    ///
    private func startScanningSynchronized() {
        debugPrint("Starting scan for Eddystone beacons")
        let services = [CBUUID(string: "FEAA")]
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        self.centralManager.scanForPeripherals(withServices: services, options: options)
    }
}

extension Scanner: CBCentralManagerDelegate {
    // MARK: CBCentralManagerDelegate callbacks
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var state = State.unknown
        switch central.state {
        case .poweredOff:
            state = .off
        case .poweredOn:
            state = .on
            // Handle state changes and user requirement
            if shouldBeScanning && !central.isScanning {
                shouldBeScanning = false
                startScanning()
            }
        case .unauthorized:
            state = .off
        default:
            state = .unknown
        }
        self.delegate?.didUpdateScannerState(scanner: self, state: state)
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey]
            as? [NSObject : AnyObject] else {
                return
        }
        
        let frameType = Eddystone.frameTypeForFrame(advertisementFrameList: serviceData)
        switch frameType {
        case .telemetry:
            self.handleTelemetryFrame(peripheral: peripheral, serviceData: serviceData, RSSI: RSSI)
            
        case .uid, .eid:
            self.handleEIDUIDFrame(peripheral: peripheral, serviceData: serviceData, RSSI: RSSI)
            
        case .url:
            self.handleURLFrame(peripheral: peripheral, serviceData: serviceData, RSSI: RSSI)
            
        default:
            debugPrint("Unable to find service data. can't process Eddystone")
        }
    }
    
    // MARK: CBCentralManagerDelegate helper methods
    /// Handle telemetry frame data
    private func handleTelemetryFrame(peripheral: CBPeripheral,
                                     serviceData: [NSObject: AnyObject],
                                     RSSI: NSNumber) {
        
        guard let beacon = nearbyBeacons.first(where: {$0.identifier == peripheral.identifier}) else {
            return
        }
        
        // Save the changing beacon data into the beacon object
        let telemetryData = Eddystone.telemetryDataForFrame(advertisementFrameList: serviceData)
        beacon.updateBeacon(telemetryData: telemetryData, eddystoneURL: nil, rssi: RSSI.intValue)
        self.nearbyBeacons.update(with: beacon)
        
        self.delegate?.didUpdateBeacon(scanner: self, beacon: beacon)
    }
    
    /// Handle EID UID frame
    private func handleEIDUIDFrame(peripheral: CBPeripheral,
                                      serviceData: [NSObject: AnyObject],
                                      RSSI: NSNumber) {
        
        guard let beacon = nearbyBeacons.first(where: {$0.identifier == peripheral.identifier}) else {
            // Newly discovered beacon. Create a new beacon object
            let beaconServiceData = serviceData[Eddystone.ServiceUUID] as? Data
            guard let beacon = Beacon(identifier: peripheral.identifier, frameData: beaconServiceData, rssi: RSSI.intValue, name: peripheral.name, namespaceFilter: namespaceFilter, filterType: rssiFilterType) else {
                return
            }
            
            self.nearbyBeacons.insert(beacon)
            self.delegate?.didFindBeacon(scanner: self, beacon: beacon)
            return
        }
        
        beacon.updateBeacon(telemetryData: nil, eddystoneURL: nil, rssi: RSSI.intValue)
        self.nearbyBeacons.update(with: beacon)
        
        self.delegate?.didUpdateBeacon(scanner: self, beacon: beacon)
    }
    
    /// Handle URL frame
    private func handleURLFrame(peripheral: CBPeripheral,
                                   serviceData: [NSObject: AnyObject],
                                   RSSI: NSNumber) {
        
        guard let beacon = nearbyBeacons.first(where: {$0.identifier == peripheral.identifier}) else {
            return
        }
        let eddystoneURL = Eddystone.parseURLFromFrame(advertisementFrameList: serviceData)
        beacon.updateBeacon(telemetryData: nil, eddystoneURL: eddystoneURL, rssi: RSSI.intValue)
        self.nearbyBeacons.update(with: beacon)
        
        self.delegate?.didUpdateBeacon(scanner: self, beacon: beacon)
    }
    
}

extension Scanner: DispatchTimerDelegate {
    // MARK: DispatchTimerProtocol delegate callbacks
    public func timerCalled(timer: DispatchTimer?) {
        // Loop through the beacon list and find which beacon has not been seen in the last 15 seconds
        self.nearbyBeacons.filterInPlace() { beacon in
            if Date().timeIntervalSince1970 - beacon.lastSeen.timeIntervalSince1970 > 15  {
                self.delegate?.didLoseBeacon(scanner: self, beacon: beacon)
                return false
            }
            return true
        }
    }
}

