//
//  GameSVTests.swift
//  
//
//  Created by Florian Claisse on 25/03/2022.
//

import XCTest
@testable import Game

class GameSVTests: XCTestCase {

    func testSolve() {
        var game = Game.default
        game.solve()
        XCTAssertEqual(game, Game.defaultSolution)
        
        game = Game.newExt(4, 4, SquareTests.ext4x4Squares, false)
        game.solve()
        XCTAssertEqual(game, Game.newExt(4, 4, SquareTests.sol4x4Squares, false))
        
        game = Game.newExt(3, 10, SquareTests.ext3x10Squares, false)
        game.solve()
        XCTAssertEqual(game, Game.newExt(3, 10, SquareTests.sol3x10Squares, false))
    }
    
    func testNbSolution() {
        var game = Game.default
        XCTAssertEqual(game.nbSolution(), 1)
        
        game = Game.newExt(5, 3, SquareTests.ext5x3wSquares, true)
        XCTAssertEqual(game.nbSolution(), 5)
    }
}
