//
//  EddystoneBeaconID.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 10/01/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

/**
 Beacon type.
 
 - eddystone: 10 bytes namespace + 6 bytes instance = 16 byte ID.
 - eddystoneEID: 8 byte ID
 */
public enum BeaconType {
    case eddystone
    case eddystoneEID
}

///
/// EddystoneBeaconID
///
/// Uniquely identifies an Eddystone compliant beacon.
///
@objc public class BeaconID: NSObject {
    
    public let beaconType: BeaconType
    
    ///
    /// unique 16-byte Beacon ID composed of a 10-byte namespace and a 6-byte instance
    /// Get hexString by doing beaconID.hexString
    ///
    @objc public let beaconID: [UInt8]
    
    ///
    /// 10 byte raw namespace data
    ///
    @objc public var namespace: Array<UInt8>? {
        guard beaconType == .eddystone else {
            return nil
        }
        return Array(beaconID[..<10])
    }
    
    ///
    /// 6 byte raw namespace data
    ///
    @objc public var instance: Array<UInt8>? {
        guard beaconType == .eddystone else {
            return nil
        }
        return Array(beaconID[10..<16])
    }
    
    ///
    /// 8 byte raw Ephemeral Identifier
    ///
    @objc public var ephemeralIdentifier: Array<UInt8>? {
        guard beaconType == .eddystoneEID else {
            return nil
        }
        return Array(beaconID[..<8])
    }
    
    ///
    /// Base64 encoded string of the byte beacon ID data
    ///
    @objc public var beaconAdvertisedId: String {
        return beaconID.data.base64EncodedString()
    }
    
    /**
     Internal initialiser
     
     - Parameter beaconType: BeaconType
     - Parameter beaconID: BeaconID
     */
    internal init(beaconType: BeaconType, beaconID: [UInt8]) {
        self.beaconID = beaconID
        self.beaconType = beaconType
        
        super.init()
    }
}


extension BeaconID {
    // MARK: CustomStringConvertible protocol requirments
    override public var description: String {
        return beaconID.hexString
    }
}

extension BeaconID {
    // MARK: Equatable protocol requirments
    public static func == (lhs: BeaconID, rhs: BeaconID) -> Bool {
        return lhs.beaconID == rhs.beaconID &&
                lhs.beaconType == rhs.beaconType
    }
}
