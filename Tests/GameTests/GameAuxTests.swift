//
//  GameAuxTests.swift
//  
//
//  Created by Florian Claisse on 25/03/2022.
//

import XCTest
@testable import Game

class GameAuxTests: XCTestCase {

    func testPrint() {
        let game = Game.default
        game.print()
    }
    
    func testDefault() {
        let game = Game.default
        checkGame(game: game, squares: SquareTests.defaultSquares)
    }
    
    func testDefaultSolution() {
        let game = Game.defaultSolution
        checkGame(game: game, squares: SquareTests.solutionSquares)
    }
}
