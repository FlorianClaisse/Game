//
//  GameMember.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//

import DequeModule


internal struct GameMember {
    internal let nb_rows: UInt
    internal let nb_cols: UInt
    internal var squares: [GameSquare]
    internal let wrapping: Bool
    internal var undo: Deque<GameMove>
    internal var redo: Deque<GameMove>
    
    internal subscript(row: UInt, col: UInt) -> GameSquare {
        get {
            let index = index(row, col)
            return squares[index]
        } set {
            let index = index(row, col)
            squares[index] = newValue
        }
    }
    
    internal subscript(row: Int, col: Int) -> GameSquare {
        get {
            let index = index(row, col)
            return squares[index]
        } set {
            let index = index(row, col)
            squares[index] = newValue
        }
    }
    
    internal init(_ rows: UInt, _ cols: UInt, _ grid: [GameSquare], _ wrapping: Bool) {
        self.nb_rows = rows
        self.nb_cols = cols
        self.squares = grid
        self.wrapping = wrapping
        self.undo = .init()
        self.redo = .init()
    }
    
    internal func index(_ row: UInt, _ col: UInt) -> Int {
        return Int(row * nb_cols + col)
    }
    
    internal func index(_ row: Int, _ col: Int) -> Int {
        return (row * Int(nb_cols)) + col
    }
}

extension GameMember: Equatable {
    internal static func == (lhs: GameMember, rhs: GameMember) -> Bool {
        return lhs.nb_rows == rhs.nb_rows && lhs.nb_cols == rhs.nb_cols && lhs.squares == rhs.squares && lhs.wrapping == rhs.wrapping
    }
}
