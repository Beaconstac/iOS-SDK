//
//  RunningAverageFilter.swift
//  EddystoneScanner
//
//  Created by Sachin Vas on 26/02/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// The running average algorithm takes 20 seconds worth of samples
/// and ignores the top and bottom 10 percent of the RSSI readings
/// and takes the mean of the remainder.

/// Similar to how iOS averages samples. https://stackoverflow.com/a/37391517/3106978

/// Very slow, there is a considerable lag before it moves on to the next beacon.
/// Suitable for applications where the device is stationary
///

internal class RunningAverageFilter: RSSIFilter {
    
    // Measurement struct used by the RunningAverageFilter
    internal struct Measurement: Comparable, Hashable {
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(rssi)
            hasher.combine(timeStamp)
        }
        
        static func <(lhs: Measurement, rhs: Measurement) -> Bool {
            return lhs.rssi < rhs.rssi
        }
        
        static func ==(lhs: Measurement, rhs: Measurement) -> Bool {
            return lhs.rssi == rhs.rssi
        }
        
        var rssi: Int
        var timeStamp: TimeInterval
    }
    
    /// Stores the filter type
    internal var filterType: RSSIFilterType
    
    /// Filtered RSSI value
    internal var filteredRSSI: Int? {
        get {
            guard measurements.count > 0 else {
                return nil
            }
            let size = measurements.count
            var startIndex = measurements.startIndex
            var endIndex = measurements.endIndex
            if (size > 2) {
                startIndex = measurements.startIndex + measurements.index(measurements.startIndex, offsetBy: size / 10 + 1)
                endIndex = measurements.startIndex + measurements.index(measurements.startIndex, offsetBy: size - size / 10 - 2)
            }
            
            var sum = 0.0
            for i in startIndex..<endIndex {
                sum += Double(measurements[i].rssi)
            }
            let runningAverage = sum / Double(endIndex - startIndex + 1)
            
            return Int(runningAverage)
        }
    }
    
    internal var measurements: [Measurement] = []
    
    internal init() {
        self.filterType = .runningAverage
    }
    
    internal func calculate(forRSSI rssi: Int) {
        
        let measurement = Measurement(rssi: rssi, timeStamp: Date().timeIntervalSince1970)
        measurements.append(measurement)
        measurements = measurements.filter({ ($0.timeStamp - Date().timeIntervalSince1970) < 20000 })
        measurements.sort(by: { $0 > $1 })
    }
}
