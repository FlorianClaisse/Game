//
//  Bool+Extension.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//


internal extension Bool {
    var uintValue: UInt { return self ? 1 : 0 }
    
    var intValue: Int { return self ? 1 : 0 }
}
