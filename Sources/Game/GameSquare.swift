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
    
    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: UInt
    
    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
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
    
    /// Start value of GameSquare
    internal static let _start: GameSquare = .blank
    /// End value of GameSquare
    internal static let _end: GameSquare = .blacku
    
    /// Get flags value.
    internal var flags: GameSquare { self.intersection(.flagMask) }
    /// Get state value.
    internal var state: GameSquare { self.intersection(.stateMask) }
    /// Get square value.
    internal var square: GameSquare { self.intersection(.squareMask) }
    
    /// Check if a given ``GameSquare`` is correct or not.
    /// - Returns: true if the value is correct, otherwise false.
    internal func _checkSquare() -> Bool {
        let state = self.intersection(.stateMask)
        let flags = self.intersection(.flagMask)
        
        if state < ._start || state > ._end { return false }
        if !flags.contains([.lighted, .error]) { return false }
        
        return true
    }
    
    /// Convert ``GameSquare`` to `String` value.
    /// - Returns: The conresponding `String`, otherwise nil.
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
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: GameSquare, rhs: GameSquare) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
