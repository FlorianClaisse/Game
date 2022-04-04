//
//  GameMove.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//

/// Move structure.
///
/// This structure is used to save the game history.
internal struct GameMove {
    internal let row: UInt
    internal let column: UInt
    internal let old: GameSquare
    internal let new: GameSquare
    
    internal init(_ row: UInt, _ col: UInt, _ old: GameSquare, _ new: GameSquare) {
        self.row = row
        self.column = col
        self.old = old
        self.new = new
    }
}
