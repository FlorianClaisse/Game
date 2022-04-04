//
//  Bool+Extension.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//


internal extension Bool {
    // Convert Bool value to uint value
    var uintValue: UInt { return self ? 1 : 0 }
    
    // Convert Bool value to int value
    var intValue: Int { return self ? 1 : 0 }
}
