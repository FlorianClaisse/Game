//
//  JSONFormat.swift
//  
//
//  Created by Florian Claisse on 20/03/2022.
//

/*
 {
   "rows": 7,
   "cols": 7,
   "wrapping": false,
   "grid": [
     "bb1bbbb",
     "bb2bbbb",
     "bbbbb2w",
     "bbbbbbb",
     "1wbbbbb",
     "bbbb2bb",
     "bbbbwbb"
   ]
 }
 */


internal struct JSONFormat: Codable {
    internal let rows: UInt
    internal let cols: UInt
    internal let wrapping: Bool
    internal let grid: [String]
    
    internal init(_ game: GameMember) {
        self.rows = game.nb_rows
        self.cols = game.nb_cols
        self.wrapping = game.wrapping
        
        var grid = [String]()
        var stringConvertion = String()
        for index in 0 ..< game.nb_cols * game.nb_rows {
            
            guard let stringValue = game.squares[Int(index)].state.toString() else { fatalError() }
            stringConvertion.append(stringValue)
            
            if stringConvertion.count == game.nb_cols {
                grid.append(stringConvertion)
                stringConvertion.removeAll()
            }
        }
        
        self.grid = grid
    }
}
