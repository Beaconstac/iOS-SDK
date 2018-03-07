//
//  GaussianFilter.swift
//  EddystoneScanner
//
//  Created by Sachin Vas on 27/02/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// A combination of bias based filter algorithms from the Beaonstac SDK
/// and Gaussian filter algorithm.
/// Its stores the last 10 rssi values, ignores the top and bottom 3, and uses the mean of remaining rssi values
/// https://stackoverflow.com/a/33627325/3106978
///

internal class GaussianFilter: RSSIFilter {
    
    private let RECORDED_RSSI_COUNT = 10
    
    internal enum BeaconAffinity: Int {
        case none = 0
        case low = 3
        case medium
        case high
    }
    
    /// Stores the filter type
    var filterType: RSSIFilterType
    
    /// Filtered RSSI value
    var filteredRSSI: Int? {
        get {
            guard recordedRSSI.count > RECORDED_RSSI_COUNT else {
                return nil
            }
            
            let sigma = 3.0
            var median: Double
            let sorted = recordedRSSI.sorted(by: { $0 < $1 })
            
            var filtered: [Int] = []
            
            for i in 3..<7 {
                filtered.append(sorted[i])
            }
            
            let len = filtered.count
            
            if len == 1 {
                median = Double(filtered[0])
            } else if len % 2 == 0 {
                median = (Double(filtered[len / 2]) + Double(filtered[len / 2 - 1])) / 2
            } else {
                median = Double(filtered[len / 2])
            }
            
            var mean = 0, meanCount = 0
            
            for i in 0..<len {
                let value = filtered[i]
                if (value < 0) && (abs(Double(value) - median) < sigma) {
                    mean += value
                    meanCount += 1
                }
            }
            
            if meanCount > 0 {
                mean /= meanCount
            } else {
                mean = previousRSSI ?? 0
            }
            previousRSSI = mean + bias
            return previousRSSI
        }
    }
    
    private var bias: Int
    
    private var recordedRSSI: [Int] = []
    
    private var previousRSSI: Int?
    
    internal init() {
        filterType = .gaussian
        bias = BeaconAffinity.medium.rawValue
    }
    
    internal func calculate(forRSSI rssi: Int) {
        if recordedRSSI.count > RECORDED_RSSI_COUNT {
            recordedRSSI.remove(at: 0)
        }
        recordedRSSI.append(rssi)
    }
}
