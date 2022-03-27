//
//  GameIOTests.swift
//  
//
//  Created by Florian Claisse on 25/03/2022.
//

import XCTest
@testable import Game

class GameIOTests: XCTestCase {

    func testLoad() {
        let game1 = Game.default
        let loadG1 = Game.load("default")
        
        XCTAssertEqual(game1, loadG1)
        
        let game2 = Game.defaultSolution
        let loadG2 = Game.load("defaultSolution")
        
        XCTAssertEqual(game2, loadG2)
    }
    
    func testSave() {
        
        let game1 = Game.default
        game1.save("testDefault")
        let gametest1 = Game.load("testDefault")
        
        XCTAssertEqual(game1, gametest1)
        
        let game2 = Game.defaultSolution
        game2.save("testDefaultSolution")
        let gametest2 = Game.load("testDefaultSolution")
        
        XCTAssertEqual(game2, gametest2)
    }

}
