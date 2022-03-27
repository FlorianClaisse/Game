//
//  GameV2Tests.swift
//  
//
//  Created by Florian Claisse on 31/01/2022.
//

import XCTest
@testable import Game

class GameV2Tests: XCTestCase {
    
    func testNewExt() {
        let game = Game.newExt(4, 4, SquareTests.ext4x4Squares, false)
        checkGameExt(game: game, rows: 4, cols: 4, squares: SquareTests.ext4x4Squares, wrapping: false)
        
        let game1 = Game.newExt(4, 4, SquareTests.sol4x4Squares, false)
        checkGameExt(game: game1, rows: 4, cols: 4, squares: SquareTests.sol4x4Squares, wrapping: false)
        
        let game2 = Game.newExt(3, 10, SquareTests.ext3x10Squares, false)
        checkGameExt(game: game2, rows: 3, cols: 10, squares: SquareTests.ext3x10Squares, wrapping: false)
        
        let game3 = Game.newExt(3, 10, SquareTests.sol3x10Squares, false)
        checkGameExt(game: game3, rows: 3, cols: 10, squares: SquareTests.sol3x10Squares, wrapping: false)
    }
    
    func testNewEmptyExt() {
        let game = Game.newEmptyExt(4, 4, false)
        checkGameExt(game: game, rows: 4, cols: 4, squares: Array(repeating: .blank, count: 4*4), wrapping: false)
    }
    
    func testEqualExt() {
        let game1 = Game.newExt(3, 10, SquareTests.ext3x10Squares, false)
        var game2 = Game.newExt(3, 10, SquareTests.ext3x10Squares, false)
        let game3 = Game.newExt(3, 10, SquareTests.ext3x10Squares, true)
        
        XCTAssertEqual(game1, game2)
        
        game2.setSquare(2, 9, .lightbulb)
        XCTAssertNotEqual(game1, game2)
        
        XCTAssertNotEqual(game1, game3)
    }
    
    // Pas besoin de la fonction testCopyExt car assignation par valeur
    
    func testGame1D() {
        var game = Game.newExt(5, 1, SquareTests.ext5x1Squares, false)
        checkGameExt(game: game, rows: 5, cols: 1, squares: SquareTests.ext5x1Squares, wrapping: false)
        
        game.playMove(0, 0, .lightbulb)
        
        XCTAssertFalse(game.isOver())
        
        game.playMove(4, 0, .lightbulb)
        
        XCTAssert(game.isOver())
    }
    
    func testWrapping5x3() {
        var game = Game.newExt(5, 3, SquareTests.ext5x3wSquares, true)
        checkGameExt(game: game, rows: 5, cols: 3, squares: SquareTests.ext5x3wSquares, wrapping: true)
        
        game.playMove(1, 1, .lightbulb)
        game.playMove(2, 0, .lightbulb)
        game.playMove(3, 2, .lightbulb)
        checkGameExt(game: game, rows: 5, cols: 3, squares: SquareTests.sol5x3wSquares, wrapping: true)
        
        XCTAssert(game.isOver())
    }
    
    func testWrapping3x3() {
        var game = Game.newExt(3, 3, SquareTests.ext3x3wSquares, true)
        checkGameExt(game: game, rows: 3, cols: 3, squares: SquareTests.ext3x3wSquares, wrapping: true)
        
        game.playMove(0, 0, .lightbulb)
        game.playMove(2, 2, .lightbulb)
        checkGameExt(game: game, rows: 3, cols: 3, squares: SquareTests.sol3x3wSquares, wrapping: true)
        
        XCTAssert(game.isOver())
    }
    
    func testWrapping2x2() {
        var game = Game.newExt(2, 2, SquareTests.ext2x2wSquares, true)
        checkGameExt(game: game, rows: 2, cols: 2, squares: SquareTests.ext2x2wSquares, wrapping: true)
        
        game.playMove(0, 1, .lightbulb)
        game.playMove(1, 0, .lightbulb)
        checkGameExt(game: game, rows: 2, cols: 2, squares: SquareTests.sol2x2wSquares, wrapping: true)
        
        XCTAssert(game.isOver())
    }
    
    func testWrappingError() {
        var game = Game.newEmptyExt(3, 3, true)
        game.setSquare(1, 1, .blacku)
        game.playMove(1, 0, .lightbulb)
        
        XCTAssert(game.isLighted(1, 0) && game.isLighted(1, 2))
        
        game.playMove(1, 2, .lightbulb)
        XCTAssert(game.hasError(1, 0) && game.hasError(1, 2))
        
        var game2 = Game.newEmptyExt(3, 3, true)
        game2.setSquare(0, 1, .blacku)
        game2.setSquare(0, 2, .black2)
        game2.setSquare(1, 1, .blacku)
        game2.setSquare(1, 2, .blacku)
        game2.playMove(2, 0, .lightbulb)
        
        XCTAssert(game2.hasError(0, 2))
    }
    
    func testUndoOne() {
        var game = Game.default
        game.playMove(0, 0, .lightbulb)
        game.playMove(1, 1, .lightbulb)
        game.playMove(2, 2, .lightbulb)
        game.playMove(0, 3, .lightbulb)
        game.playMove(1, 6, .lightbulb)
        game.playMove(3, 6, .lightbulb)
        game.playMove(4, 4, .lightbulb)
        game.playMove(5, 0, .lightbulb)
        
        XCTAssertEqual(game.getSquare(6, 0), .lighted)
        
        game.playMove(6, 0, .lightbulb)
        XCTAssertEqual(game.getSquare(6, 0), ._lightedbulberr)
        
        game.undo()
        XCTAssertEqual(game.getSquare(6, 0), .lighted)
        
        game.playMove(6, 1, .lightbulb)
        game.playMove(5, 5, .lightbulb)
        checkGame(game: game, squares: SquareTests.solutionSquares)
    }
    
    func testUndoRedoSome() {
        var game = Game.default
        game.playMove(0, 0, .lightbulb)
        game.playMove(1, 1, .lightbulb)
        game.playMove(2, 2, .lightbulb)
        game.playMove(0, 3, .lightbulb)
        game.playMove(1, 6, .lightbulb)
        game.playMove(3, 6, .lightbulb)
        game.playMove(4, 4, .lightbulb)
        game.playMove(5, 5, .lightbulb)
        game.playMove(5, 1, .lightbulb)
        
        game.undo()
        game.undo()
        game.redo()
        
        game.playMove(5, 0, .lightbulb)
        game.playMove(6, 1, .lightbulb)
        
        checkGame(game: game, squares: SquareTests.solutionSquares)
    }
    
    func testUndoRedoAll() {
        var game = Game.default
        game.playMove(0, 0, .lightbulb)
        game.playMove(1, 1, .lightbulb)
        game.playMove(2, 2, .lightbulb)
        game.playMove(0, 3, .lightbulb)
        game.playMove(1, 6, .lightbulb)
        game.playMove(3, 6, .lightbulb)
        game.playMove(4, 4, .lightbulb)
        game.playMove(5, 0, .lightbulb)
        game.playMove(5, 5, .lightbulb)
        game.playMove(6, 1, .lightbulb)
        checkGame(game: game, squares: SquareTests.solutionSquares)
        
        for _ in 0 ..< 10 { game.undo() }
        checkGame(game: game, squares: SquareTests.defaultSquares)
        
        for _ in 0 ..< 10 { game.redo() }
        checkGame(game: game, squares: SquareTests.solutionSquares)
    }
    
    func testRestartUndo() {
        var game = Game.default
        game.playMove(0, 0, .lightbulb)
        game.playMove(1, 1, .lightbulb)
        game.playMove(2, 2, .lightbulb)
        game.playMove(2, 2, .blank)
        game.restart()
        game.undo()
        checkGame(game: game, squares: SquareTests.defaultSquares)
    }
    
    
}
