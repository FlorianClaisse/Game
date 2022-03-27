//
//  GameSquare.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//


/// Different squares used in the ``Game``.
///
/// The value of a ``GameSquare`` is an integer represented on one byte, with a
/// low-order half-byte that codes for the square state (``blank``, ``black``, ``lightbulb`` or ``mark``)
/// and a high-order half-byte that codes for the additionnal
/// square flags (``lighted`` or ``error``). While each square has a single state, it can
/// have zero, one or several flags. For instance, a ``lightbulb`` can have both the ``lighted`` and ``error`` flags.
/// In this case, the ``rawValue`` is   ``lightbulb`` | ``lighted`` | ``error``, using the
/// bitwise OR operator (|). For more details on bitwise operations, see [here](https://en.wikipedia.org/wiki/Bitwise_operations_in_C)
public struct GameSquare: OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    /// A blank square
    public static let blank = GameSquare([])
    
    /// A light bulb
    public static let lightbulb = GameSquare(rawValue: 1)
    
    /// A marked square (as not-a-light)
    public static let mark = GameSquare(rawValue: 2)
    
    /// Black wall base code
    public static let black = GameSquare(rawValue: 8)
    
    /// A numbered black wall (with 0 adjacent lights)
    public static let black0 = GameSquare(rawValue: GameSquare.black.rawValue)
    
    /// A numbered black wall (with 1 adjacent lights)
    public static let black1 = GameSquare(rawValue: GameSquare.black.rawValue + 1)
    
    /// A numbered black wall (with 2 adjacent lights)
    public static let black2 = GameSquare(rawValue: GameSquare.black.rawValue + 2)
    
    /// A numbered black wall (with 3 adjacent lights)
    public static let black3 = GameSquare(rawValue: GameSquare.black.rawValue + 3)
    
    /// A numbered black wall (with 4 adjacent lights)
    public static let black4 = GameSquare(rawValue: GameSquare.black.rawValue + 4)
    
    /// An unnumbered black wall (any number of adjacent lights)
    public static let blacku = GameSquare(rawValue: GameSquare.black.rawValue + 5)
    
    /// Lighted flag
    public static let lighted = GameSquare(rawValue: 16)
    
    /// Error flag
    public static let error = GameSquare(rawValue: 32)
    
    /// State mask used in ``GameSquare``
    public static let stateMask = GameSquare(rawValue: 0x0F)
    
    /// Flag mask used in ``GameSquare``
    public static let flagMask = GameSquare(rawValue: 0xF0)
    
    /// Square mask used in ``GameSquare``
    public static let squareMask = GameSquare(rawValue: 0xFF)
    
    internal static let _start: GameSquare = .blank
    internal static let _end: GameSquare = .blacku
    
    internal var flags: GameSquare { self.intersection(.flagMask) }
    
    internal var state: GameSquare { self.intersection(.stateMask) }
    
    internal var square: GameSquare { self.intersection(.squareMask) }
    
    internal func _checkSquare() -> Bool {
        let state = self.intersection(.stateMask)
        let flags = self.intersection(.flagMask)
        
        if state < ._start || state > ._end { return false }
        if !flags.contains([.lighted, .error]) { return false }
        
        return true
    }
    
    internal func toString() -> String? {
        let state = self.intersection(.stateMask)
        let flags = self.intersection(.flagMask)
        
        if state == .blank && flags.contains(.lighted) { return "." }
        
        switch state {
        case .blank: return "b"
        case .lightbulb: return "*"
        case .mark: return "-"
        case .black0: return "0"
        case .black1: return "1"
        case .black2: return "2"
        case .black3: return "3"
        case .black4: return "4"
        case .blacku: return "w"
        default: return nil
        }
    }
}

extension GameSquare: Comparable {
    public static func < (lhs: GameSquare, rhs: GameSquare) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
