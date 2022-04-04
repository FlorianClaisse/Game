//
//  String+Extension.swift
//  
//
//  Created by Florian Claisse on 18/03/2022.
//


internal extension String {
    
    
    /// Convert string value to a ``GameSquare``
    /// - Returns: ``GameSquare`` value, otherwise nil.
    func toSquare() -> GameSquare? {
        switch self {
        case "b": return .blank
        case "*": return .lightbulb
        case "-": return .mark
        case "0": return .black0
        case "1": return .black1
        case "2": return .black2
        case "3": return .black3
        case "4": return .black4
        case "w": return .blacku
        default: return nil
        }
    }
}
