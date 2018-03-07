//
//  RSSIFilter.swift
//  EddystoneScanner
//
//  Created by Sachin Vas on 22/02/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// FilterType
///
/// Enum to define the filter to use
@objc public enum RSSIFilterType: Int {
    case kalman
    case arma
    case gaussian
    case runningAverage
}

///
/// RSSIFilterDelegate
///
/// RSSI signal filter protocol that all filters need to conform to
///
internal protocol RSSIFilter {
    /// Defines the filter type
    var filterType: RSSIFilterType { get }
    
    /// Filtered RSSI value
    var filteredRSSI: Int? { get }
    
    /// Function to filter RSSI on current signal
    func calculate(forRSSI rssi: Int)
}
