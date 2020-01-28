//
//  Util.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 14/01/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

public extension Collection where Iterator.Element == UInt8 {
    
    //
    // Converts the UInt8 array into a Data object
    //
    var data: Data {
        return Data(self)
    }
    
    ///
    /// Converts the UInt8 array into its quvivalent hex string
    ///
    var hexString: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
    
}

/**
 Convert the bytes array into a UInt object
 
 - Parameter byteArray: The `ArraySlice<UInt8>` byte array
 */
internal func bytesToUInt(byteArray: ArraySlice<UInt8>) -> UInt? {
    guard byteArray.count <= 4 else {
        debugPrint("Byte array cannot be converted into a UInt object. Elements greater that 4")
        return nil
    }
    
    var result: UInt = 0
    for idx in 0..<(byteArray.count) {
        let shiftAmount = UInt((byteArray.count) - idx - 1) * 8
        let value = UInt(byteArray[byteArray.startIndex + idx])
        result += value << shiftAmount
    }
    return result
}
