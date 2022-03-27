//
//  GameCheck.swift
//  
//
//  Created by Florian Claisse on 25/03/2022.
//

import XCTest
@testable import Game

func checkGameExt(game: Game, rows: UInt, cols: UInt, squares: [GameSquare], wrapping: Bool) {
    
    XCTAssertEqual(game.numberOfRows, rows)
    XCTAssertEqual(game.numberOfColumns, cols)
    XCTAssertEqual(game.isWrapping, wrapping)
    
    for i in 0 ..< rows {
        for j in 0 ..< cols {
            let gameSquare = game.getSquare(i, j)
            let square = squares[Int(i * cols + j)]
            XCTAssertEqual(gameSquare, square)
        }
    }
}

func checkGame(game: Game, squares: [GameSquare]) {
    checkGameExt(game: game, rows: defaultSize, cols: defaultSize, squares: squares, wrapping: false)
}
