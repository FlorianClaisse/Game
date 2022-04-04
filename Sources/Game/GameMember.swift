//
//  GameMember.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//

import DequeModule


internal struct GameMember {
    /// Number of rows.
    internal let nb_rows: UInt
    /// Number of columns.
    internal let nb_cols: UInt
    /// The grid of square.
    internal var squares: [GameSquare]
    /// Wrapping option.
    internal let wrapping: Bool
    /// Stack to undo move.
    internal var undo: Deque<GameMove>
    /// Stack to redo move.
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
    
    /// Convert `rows`, `cols` value to index value.
    internal func index(_ row: UInt, _ col: UInt) -> Int {
        return Int(row * nb_cols + col)
    }
    
    /// Convert `rows`, `cols` value to index value.
    internal func index(_ row: Int, _ col: Int) -> Int {
        return (row * Int(nb_cols)) + col
    }
}

extension GameMember: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    internal static func == (lhs: GameMember, rhs: GameMember) -> Bool {
        return lhs.nb_rows == rhs.nb_rows && lhs.nb_cols == rhs.nb_cols && lhs.squares == rhs.squares && lhs.wrapping == rhs.wrapping
    }
}
