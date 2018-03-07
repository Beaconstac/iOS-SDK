//
//  ARMAFilter.swift
//  EddystoneScanner
//
//  Created by Sachin Vas on 22/02/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// ArmaFilter
///
/// This filter calculates its rssi on base of an auto regressive moving average (ARMA)
/// It needs only the current value to do this;
/// the general formula is  n(t) = n(t-1) - c * (n(t-1) - n(t))
/// where c is a coefficient, that denotes the smoothness - the lower the value, the smoother the average
/// Note: a smoother average needs longer to "settle down"
/// Note: For signals, that change rather frequently (say, 1Hz or faster) and tend to vary more a recommended value would be 0,1 (that means the actual value is changed by 10% of the difference between the actual measurement and the actual average)
/// For signals at lower rates (10Hz) a value of 0.25 to 0.5 would be appropriate
////
internal class ArmaFilter: RSSIFilter {
    
    /// Stores the filter type
    internal let filterType: RSSIFilterType = .arma
    
    /// Filtered RSSI value
    internal var filteredRSSI: Int?
    
    private let sArmaCoefficient: Float
    
    private let ARMA_FILTER_PROCESS_NOISE: Float = 0.15
    
    internal init() {
        sArmaCoefficient = ARMA_FILTER_PROCESS_NOISE
    }
    
    internal func calculate(forRSSI rssi: Int) {
        guard rssi < 0 else {
            return
        }
        
        if let x = filteredRSSI {
            filteredRSSI = Int(Float(x) - sArmaCoefficient * Float(x - rssi))
            return
        }
        filteredRSSI = rssi
    }
}

