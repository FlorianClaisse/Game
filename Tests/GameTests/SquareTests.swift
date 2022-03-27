//
//  File.swift
//  
//
//  Created by Florian Claisse on 30/01/2022.
//

@testable import Game

extension GameSquare {
    internal static let _lightedbulb: GameSquare = [.lightbulb, .lighted]
    internal static let _black2err: GameSquare = [.black2, .error]
    internal static let _lightedbulberr: GameSquare = [.lightbulb, .lighted, .error]
}

struct SquareTests {
    
    static let defaultSquares: [GameSquare] = [
        .blank, .blank, .black1, .blank, .blank, .blank, .blank,
        .blank, .blank, .black2, .blank, .blank, .blank, .blank,
        .blank, .blank, .blank, .blank, .blank, .blacku, .black2,
        .blank, .blank, .blank, .blank, .blank, .blank, .blank,
        .black1, .blacku, .blank, .blank, .blank, .blank, .blank,
        .blank, .blank, .blank, .blank, .black2, .blank, .blank,
        .blank, .blank, .blank, .blank, .blacku, .blank, .blank,
    ]
    
    static let solutionSquares: [GameSquare] = [
        ._lightedbulb, .lighted, .black1, ._lightedbulb, .lighted, .lighted, .lighted,
        .lighted, ._lightedbulb, .black2, .lighted, .lighted, .lighted, ._lightedbulb,
        .lighted, .lighted, ._lightedbulb, .lighted, .lighted, .blacku, .black2,
        .lighted, .lighted, .lighted, .lighted, .lighted, .lighted, ._lightedbulb,
        .black1, .blacku, .lighted, .lighted, ._lightedbulb, .lighted, .lighted,
        ._lightedbulb, .lighted, .lighted, .lighted, .black2, ._lightedbulb, .lighted,
        .lighted, ._lightedbulb, .lighted, .lighted, .blacku, .lighted, .lighted,
    ]
    
    static let otherSquares: [GameSquare] = [
        ._lightedbulberr, .lighted, .black1, .blank, .blank, .blank, .blank,
        .lighted, .blank, .black2, .blank, .blank, .blank, .blank,
        .lighted, .blank, .blank, .blank, .blank, .blacku, ._black2err,
        ._lightedbulberr, .lighted, .lighted, .lighted, .lighted, .lighted, .lighted,
        .black1, .blacku, .blank, .blank, .blank, .blank, .blank,
        .blank, .blank, .blank, .blank, .black2, .blank, .blank,
        .blank, .blank, .blank, .blank, .blacku, .blank, .mark,
    ]
    
    static let ext4x4Squares: [GameSquare] = [
        .blank, .blank, .black0, .blank,
        .blank, .blacku, .blank, .blank,
        .blank, .blank, .black2, .blank,
        .blank, .blank, .blank, .blank,
    ]
    
    static let sol4x4Squares: [GameSquare] = [
        ._lightedbulb, .lighted, .black0, .lighted,
        .lighted, .blacku, .lighted, ._lightedbulb,
        .lighted, ._lightedbulb, .black2, .lighted,
        .lighted, .lighted, ._lightedbulb, .lighted,
    ]
    
    static let ext3x10Squares: [GameSquare] = [
        .blank, .blank, .blank, .black1, .blank, .blank, .blank, .blank, .black1, .blacku,
        .black1, .blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank, .black1,
        .blacku, .black0, .blank, .blank, .blank, .blank, .black0, .blank, .blank, .blank,
    ]
    
    static let sol3x10Squares: [GameSquare] = [
        ._lightedbulb, .lighted, .lighted, .black1, .lighted, .lighted, .lighted, ._lightedbulb, .black1, .blacku,
        .black1, .lighted, .lighted, ._lightedbulb, .lighted, .lighted, .lighted, .lighted, .lighted, .black1,
        .blacku, .black0, .lighted, .lighted, ._lightedbulb, .lighted, .black0, .lighted, .lighted, ._lightedbulb,
    ]
    
    static let ext5x1Squares: [GameSquare] = [
        .blank,
        .blank,
        .black0,
        .blank,
        .blank,
    ]
    
    static let ext2x2wSquares: [GameSquare] = [
        .black4, .blank,
        .blank, .blank,
    ]
    
    static let sol2x2wSquares: [GameSquare] = [
        .black4, ._lightedbulb,
        ._lightedbulb, .lighted
    ]
    
    static let ext3x3wSquares: [GameSquare] = [
        .blank, .blacku, .black2,
        .blank, .blacku, .blacku,
        .blank, .blank, .blank,
    ]
    
    static let sol3x3wSquares: [GameSquare] = [
        ._lightedbulb, .blacku, .black2,
        .lighted, .blacku, .blacku,
        .lighted, .lighted, ._lightedbulb,
    ]
    
    static let ext5x3wSquares: [GameSquare] = [
        .blank, .blank, .blank,
        .blacku, .blank, .black1,
        .blank, .black2, .blank,
        .blank, .blank, .blank,
        .blank, .blank, .blank
    ]
    
    static let sol5x3wSquares: [GameSquare] = [
        .lighted, .lighted, .lighted,
        .blacku, ._lightedbulb, .black1,
        ._lightedbulb, .black2, .lighted,
        .lighted, .lighted, ._lightedbulb,
        .lighted, .lighted, .lighted,
    ]
}
