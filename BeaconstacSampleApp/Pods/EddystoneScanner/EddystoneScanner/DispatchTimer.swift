//
//  DispatchTimer.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 30/11/17.
//  Copyright © 2017 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// DispatchTimerDelegate
///
/// Implement this to receive callbacks when the timer is called
@objc public protocol DispatchTimerDelegate {
    func timerCalled(timer: DispatchTimer?)
}

///
/// DispatchTimer
///
/// Timer class to create a background timer on a queue
///
public class DispatchTimer: NSObject {
    
    // MARK: Public properties
    /// Interval to run the timer
    public let repeatingInterval: Double
    /// DispatchTimerDelegate to recieve delegate callbacks
    public var delegate: DispatchTimerDelegate?
    
    // MARK: Private properties
    private var sourceTimer: DispatchSourceTimer?
    private let queue: DispatchQueue
    
    public init(repeatingInterval: Double, queueLabel: String) {
        queue = DispatchQueue(label: queueLabel)
        sourceTimer = DispatchSource.makeTimerSource(queue: queue)
        
        self.repeatingInterval = repeatingInterval
        
        super.init()
    }
    
    /// Start the timer
    public func startTimer() {
        sourceTimer?.schedule(deadline: .now(), repeating: repeatingInterval, leeway: .seconds(10))
        sourceTimer?.setEventHandler { [weak self] in
            self?.delegate?.timerCalled(timer: self)
        }
        sourceTimer?.resume()
    }
    
    /// Stop the timer
    public func stopTimer() {
        self.sourceTimer?.suspend()
    }
    
}
