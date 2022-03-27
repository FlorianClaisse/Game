//
//  GameDirection.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//

internal enum GameDirection: UInt {
    case here
    case up
    case down
    case left
    case right
    case upLeft
    case upRight
    case downLeft
    case downRight
}

extension GameDirection {
    internal var iOffset: Int {
        switch self {
        case .here: return 0
        case .up: return -1
        case .down: return +1
        case .left: return 0
        case .right: return 0
        case .upLeft: return -1
        case .upRight: return -1
        case .downLeft: return 1
        case .downRight: return 1
        }
    }
    
    internal var jOffset: Int {
        switch self {
        case .here: return 0
        case .up: return 0
        case .down: return 0
        case .left: return -1
        case .right: return 1
        case .upLeft: return -1
        case .upRight: return 1
        case .downLeft: return -1
        case .downRight: return 1
        }
    }
}
