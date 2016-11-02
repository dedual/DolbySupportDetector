//
//  String+FourCharCodeExtension.swift
//  Dolby Swift Sampler
//
//  Created by Nicolas Dedual on 9/4/16.
//  Copyright © 2016 DeEnt. All rights reserved.
//

import Foundation

/**
 Extension used to covert between a 4 character CHAR code into a Swift String
 */
extension FourCharCode: ExpressibleByStringLiteral {
    public init(stringLiteral: StringLiteralType) {
        if stringLiteral.utf16.count != 4 {
            fatalError("FourCharCode length must be 4!")
        }
        var code: FourCharCode = 0
        for char in stringLiteral.utf16 {
            if char > 0xFF {
                fatalError("FourCharCode must contain only ASCII characters!")
            }
            code = (code << 8) + FourCharCode(char)
        }
        self = code
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        fatalError("FourCharCode must contain 4 ASCII characters!")
    }
    
    public init(unicodeScalarLiteral value: String) {
        fatalError("FourCharCode must contain 4 ASCII characters!")
    }
    
    public init(fromString: String) {
        self.init(stringLiteral: fromString)
    }
    
    public init(networkOrder value: UInt32) {
        self.init(bigEndian: value)
    }
    
    public var fourCharString: String {
        let bytes: [CChar] = [
            CChar(truncatingBitPattern: (self >> 24) & 0xFF),
            CChar(truncatingBitPattern: (self >> 16) & 0xFF),
            CChar(truncatingBitPattern: (self >> 8) & 0xFF),
            CChar(truncatingBitPattern: self & 0xFF),
            ]
        
        
        let data = Data(bytes: bytes, count: 4)
        return String(data: data, encoding: String.Encoding.isoLatin1)!
    }
    
    public var possibleFourCharString: String {
        var bytes: [CChar] = [
            CChar(truncatingBitPattern: (self >> 24) & 0xFF),
            CChar(truncatingBitPattern: (self >> 16) & 0xFF),
            CChar(truncatingBitPattern: (self >> 8) & 0xFF),
            CChar(truncatingBitPattern: self & 0xFF),
            0
        ]
        for i in 0..<4 {
            if bytes[i] < 0x20 || bytes[i] > 0x7E {
                bytes[i] = CChar(("?" as UnicodeScalar).value)
            }
        }
        return String(cString:bytes)
    }
}
