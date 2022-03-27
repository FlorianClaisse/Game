//
//  GameV1Tests.swift
//  
//
//  Created by Florian Claisse on 25/03/2022.
//

import XCTest
@testable import Game

class GameV1Tests: XCTestCase {
    
    let emptyDefaultArray: [GameSquare] = .init(repeating: .blank, count: Int(defaultSize * defaultSize))

    func testNew() {
        let game = Game.new(SquareTests.defaultSquares)
        checkGame(game: game, squares: SquareTests.defaultSquares)
    }
    
    func testNewEmpty() {
        let game = Game.newEmpty()
        checkGame(game: game, squares: emptyDefaultArray)
    }
    
    // Pas besoin de la fonction testCopy car assignation par valeur
    // Pas besoin de la fonction testDelete cat memoire géré dynamiquement
    
    func testEqual() {
        let game1 = Game.default
        let game2 = Game.default
        var game3 = Game.default
        var game4 = Game.default
        
        XCTAssertEqual(game1, game2)
        
        game3.playMove(0, 0, .lightbulb)
        XCTAssertNotEqual(game1, game3)
        
        game4.setSquare(0, 0, .lighted)
        XCTAssertNotEqual(game1, game4)
    }
    
    func testSetSquare() {
        var game = Game.default
        game.setSquare(0, 0, .lightbulb)
        game.setSquare(0, 2, .blank)
        game.setSquare(1, 1, .mark)
        game.setSquare(2, 2, [.black3, .error])
        game.setSquare(3, 3, [.lightbulb, .lighted, .error])
        let s1 = game.getSquare(0, 0)
        let s2 = game.getSquare(0, 2)
        let s3 = game.getSquare(1, 1)
        let s4 = game.getSquare(2, 2)
        let s5 = game.getSquare(3, 3)
        let s6 = game.getSquare(0, 1)
        
        XCTAssertEqual(s1, .lightbulb)
        XCTAssertEqual(s2, .blank)
        XCTAssertEqual(s3, .mark)
        XCTAssertEqual(s4, [.black3, .error])
        XCTAssertEqual(s5, [.lightbulb, .lighted, .error])
        XCTAssertEqual(s6, .blank)
    }
    
    func testGetSquare() {
        let game = Game.new(SquareTests.otherSquares)
        
        let s1 = game.getSquare(0, 0)
        let s2 = game.getSquare(0, 1)
        let s3 = game.getSquare(0, 2)
        let s4 = game.getSquare(2, 6)
        let s5 = game.getSquare(6, 6)
        
        XCTAssertEqual(s1, [.lightbulb, .lighted, .error])
        XCTAssertEqual(s2, .lighted)
        XCTAssertEqual(s3, .black1)
        XCTAssertEqual(s4, [.black2, .error])
        XCTAssertEqual(s5, .mark)
    }
    
    func testGetState() {
        let game = Game.new(SquareTests.otherSquares)
        
        let s1 = game.getState(0, 0)
        let s2 = game.getState(0, 1)
        let s3 = game.getState(0, 2)
        let s4 = game.getState(2, 6)
        
        XCTAssertEqual(s1, .lightbulb)
        XCTAssertEqual(s2, .blank)
        XCTAssertEqual(s3, .black1)
        XCTAssertEqual(s4, .black2)
    }
    
    func testGetFlags() {
        let game = Game.new(SquareTests.otherSquares)
        
        let s1 = game.getFlags(0, 0)
        let s2 = game.getFlags(0, 1)
        let s3 = game.getFlags(0, 2)
        let s4 = game.getFlags(2, 6)
        
        XCTAssertEqual(s1, [.lighted, .error])
        XCTAssertEqual(s2, .lighted)
        XCTAssertEqual(s3, [])
        XCTAssertEqual(s4, .error)
    }
    
    func testIsState() {
        let game = Game.new(SquareTests.otherSquares)
        
        XCTAssert(game.isLightbulb(0, 0) && !game.isLightbulb(0, 1))
        XCTAssert(game.isBlack(0, 2) && game.isBlack(2, 5) && !game.isBlack(0, 1))
        XCTAssert(game.isBlank(0, 1) && !game.isBlank(0, 0))
        XCTAssert(game.isMarked(6, 6) && !game.isMarked(0, 0))
        
        XCTAssertEqual(game.getBlackNumber(0, 2), 1)
        XCTAssertEqual(game.getBlackNumber(2, 6), 2)
        XCTAssertEqual(game.getBlackNumber(2, 5), -1)
    }
    
    func testHasFlags() {
        let game = Game.new(SquareTests.otherSquares)
        
        XCTAssert(game.isLighted(0, 0) && game.isLighted(0, 1) && !game.isLighted(1, 1))
        XCTAssert(game.hasError(0, 0) && game.hasError(2, 6) && !game.hasError(0, 1))
    }
    
    func testPlayMove() {
        var game = Game.default
        game.playMove(0, 0, .lightbulb)
        game.playMove(3, 0, .lightbulb)
        game.playMove(6, 6, .mark)
        game.playMove(0, 6, .lightbulb)
        game.playMove(0, 6, .blank)
        
        checkGame(game: game, squares: SquareTests.otherSquares)
        
        var game2 = Game.default
        game2.playMove(0, 0, .lightbulb)
        game2.playMove(1, 1, .lightbulb)
        game2.playMove(2, 2, .lightbulb)
        game2.playMove(0, 3, .lightbulb)
        game2.playMove(1, 6, .lightbulb)
        game2.playMove(3, 6, .lightbulb)
        game2.playMove(4, 4, .lightbulb)
        game2.playMove(5, 0,.lightbulb)
        game2.playMove(5, 5,.lightbulb)
        game2.playMove(6, 1,.lightbulb)
        checkGame(game: game2, squares: SquareTests.solutionSquares)
    }
    
    func testCheckMove() {
        let game = Game.new(SquareTests.otherSquares)
        
        XCTAssert(game.checkMove(1, 1, .lightbulb) &&
                  game.checkMove(0, 0, .blank) &&
                  game.checkMove(1, 1, .mark))
        
        XCTAssert(!game.checkMove(1, 1, [.lightbulb, .lighted, .error]) &&
                  !game.checkMove(0, 0, [.blank, .lighted]) &&
                  !game.checkMove(1, 1, [.mark, .error]))
        
        XCTAssert(!game.checkMove(0, 2, .lightbulb) &&
                  !game.checkMove(2, 5, .blank))
        
        XCTAssert(!game.checkMove(7, 7, .lightbulb) &&
                  !game.checkMove(0, 10, .blank))
    }
    
    func testIsOver() {
        let game = Game.default
        XCTAssertFalse(game.isOver())
        
        let game2 = Game.defaultSolution
        XCTAssert(game2.isOver())
        
        var game3 = Game.newEmpty()
        game3.playMove(0, 0, .lightbulb)
        game3.playMove(0, 1, .mark)
        game3.playMove(1, 1, .lightbulb)
        game3.playMove(2, 2, .lightbulb)
        game3.playMove(3, 3, .lightbulb)
        game3.playMove(4, 4, .lightbulb)
        game3.playMove(5, 5, .lightbulb)
        XCTAssertFalse(game.isOver())
        
        game3.playMove(6, 6, .lightbulb)
        XCTAssert(game3.isOver())
        
        var game4 = Game.default
        for i in 0 ..< defaultSize {
            for j in 0 ..< defaultSize {
                if !game4.isBlack(i, j) {
                    game4.playMove(i, j, .lightbulb)
                }
            }
        }
        
        XCTAssertFalse(game.isOver())
    }
    
    func testRestart() {
        var game = Game.defaultSolution
        game.restart()
        checkGame(game: game, squares: SquareTests.defaultSquares)
        
        var game2 = Game.new(SquareTests.otherSquares)
        game2.restart()
        checkGame(game: game2, squares: SquareTests.defaultSquares)
    }
    
    func testUpdateFlags() {
        var game = Game.default
        game.setSquare(0, 0, .lightbulb)
        game.setSquare(3, 0, .lightbulb)
        game.setSquare(6, 6, .mark)
        game.setSquare(0, 6, .lightbulb)
        game.setSquare(0, 6, .blank)
        game.updateFlags()
        checkGame(game: game, squares: SquareTests.otherSquares)
        
        var game1 = Game.default
        game1.setSquare(0, 0, .lightbulb)
        game1.setSquare(1, 1, .lightbulb)
        game1.setSquare(2, 2, .lightbulb)
        game1.setSquare(0, 3, .lightbulb)
        game1.setSquare(1, 6, .lightbulb)
        game1.setSquare(3, 6, .lightbulb)
        game1.setSquare(4, 4, .lightbulb)
        game1.setSquare(5, 0, .lightbulb)
        game1.setSquare(5, 5, .lightbulb)
        game1.setSquare(6, 1, .lightbulb)
        game1.updateFlags()
        checkGame(game: game1, squares: SquareTests.solutionSquares)
    }

}
