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


/// Struct representation to containt json file format
internal struct JSONFormat: Codable {
    /// number of rows
    internal let rows: UInt
    /// Number of columns
    internal let cols: UInt
    /// Wrapping option
    internal let wrapping: Bool
    /// Array of GameSquare convert in string
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
