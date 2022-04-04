//
//  Game.swift
//  
//
//  Created by Florian Claisse on 02/01/2022.
//

import Foundation


public struct Game {
    
    // MARK: - Life Cycle
    
    private var game: GameMember
    private let rowRange: Range<UInt>
    private let columnRange: Range<UInt>
    
    private init(_ rows: UInt, _ cols: UInt, _ grid: [GameSquare], _ wrapping: Bool) {
        assert(rows >= minSize && rows <= maxSize)
        assert(cols >= minSize && cols <= maxSize)
        assert((rows * cols) == grid.count)
        
        let game = GameMember(rows, cols, grid, wrapping)
        self.game = game
        self.rowRange = 0 ..< game.nb_rows
        self.columnRange = 0 ..< game.nb_cols
    }
    
    private init(_ format: JSONFormat) {
        var gameGrid = [GameSquare]()
        
        for item in format.grid {
            let row = Array(item)
            for value in row {
                guard let square = String(value).toSquare() else { fatalError() }
                gameGrid.append(square)
            }
        }
        
        self.init(format.rows, format.cols, gameGrid, format.wrapping)
    }
}


// MARK: - Game

extension Game {
    
    /// Creates a new ``Game`` instance with ``defaultSize`` and initializes it.
    ///
    /// - Parameter squares: An array describing the initial square values [row-major storage](https://en.wikipedia.org/wiki/row-_and_column-major_order)
    /// - Precondition: `squares` must be an initialized array of ``defaultSize`` with ``GameSquare``
    /// - Returns: The new ``Game`` instance.
    public static func new(_ squares: [GameSquare]) -> Game {
        return Game.newExt(defaultSize, defaultSize, squares, false)
    }
    
    /// Creates a new empty ``Game`` with ``defaultSize``.
    ///
    /// All ``GameSquare`` are initialized with ``GameSquare/blank`` squares.
    /// - Returns: The new ``Game`` instance
    public static func newEmpty() -> Game {
        return Game.newEmptyExt(defaultSize, defaultSize, false)
    }
    
    // Les structures sont assignées par valeur et non par reference donc pas besoin de la fonction copy
    // La fonction equal se trouve dans une extension plus bas
    // La fonction delete est inutile car c'est une structure et il n'y a pas de compteur de reference
    
    /// Sets the value of a given square.
    ///
    /// This function is useful for initializing the squares of an empty game.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value
    /// - Precondition: `row` < ``Game/Game/numberOfRows``
    /// - Precondition: `col` < ``Game/Game/numberOfColumns``
    /// - Precondition: `square` must be a valid ``GameSquare`` value.
    public mutating func setSquare(_ row: UInt, _ col: UInt, _ square: GameSquare) {
        game[row, col] = square
    }
    
    /// Gets the value of a given square.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: The ``GameSquare`` value
    public func getSquare(_ row: UInt, _ col: UInt) -> GameSquare {
        return game[row, col]
    }
    
    /// Gets the state of a given square.
    ///
    /// See description of ``GameSquare``.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: The square state.
    public func getState(_ row: UInt, _ col: UInt) -> GameSquare {
        return game[row, col].state
    }
    
    /// Gets the flags of a given square.
    ///
    /// See description of ``GameSquare``.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: The square state.
    public func getFlags(_ row: UInt, _ col: UInt) -> GameSquare {
        return game[row, col].flags
    }
    
    
    /// Test if a given square is ``GameSquare/blank``.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square is ``GameSquare/blank``, otherwise false.
    public func isBlank(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].state == .blank
    }
    
    /// Test if a given square is ``GameSquare/lightbulb``.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square is ``GameSquare/lightbulb``, otherwise false.
    public func isLightbulb(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].state == .lightbulb
    }
    
    /// Test if a given square is ``GameSquare/black`` (whether or not it is numbered).
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square is ``GameSquare/black``, otherwise false.
    public func isBlack(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].state.contains(.black)
    }
    
    
    /// Get the number of ``GameSquare/lightbulb`` expected against a ``GameSquare/black`` wall.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Precondition: The square at position (`row`, `col`) must be a ``GameSquare/black`` wall (either numbered or unumbered).
    /// - Returns: The black wall number, or -1 if it is ``GameSquare/blacku``
    public func getBlackNumber(_ row: UInt, _ col: UInt) -> Int {
        let state = game[row, col].state
        assert(state.contains(.black))
        
        if state == .blacku { return -1 }
        
        return Int(state.rawValue - GameSquare.black.rawValue)
    }
    
    /// Test if a given square is ``GameSquare/mark``.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square is ``GameSquare/mark``, otherwise false.
    public func isMarked(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].state == .mark
    }
    
    /// Test if a given square is ``GameSquare/lighted``.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square is ``GameSquare/lighted``, otherwise false.
    public func isLighted(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].flags.contains(.lighted)
    }
    
    /// Test if a given square has ``GameSquare/error`` flag.
    ///
    /// An error can only occur on an numbered ``GameSquare/black`` wall or on a ``GameSquare/lightbulb``.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Returns: true if the square has an ``GameSquare/error``, otherwise false.
    public func hasError(_ row: UInt, _ col: UInt) -> Bool {
        return game[row, col].flags.contains(.error)
    }
    
    
    /// Checks if a given move is legal.
    ///
    /// This function checks that it is possible to play a move at a given
    /// position in the grid. More precisely, a move is said to be legal: 1) if the
    /// coordinates (`row`, `col`) are inside the grid, 2) if `square` is either a ``GameSquare/blank``,
    /// ``GameSquare/lightbulb`` or ``GameSquare/mark`` square, and 3) if the current square at (`row`, `col`)
    /// is not a ``GameSquare/black`` square.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value
    /// - Returns: false if the mive is not legal, otherwise true.
    public func checkMove(_ row: UInt, _ col: UInt, _ square: GameSquare) -> Bool {
        if row > game.nb_rows - 1 { return false }
        if col > game.nb_cols - 1 { return false }
        if square != .blank && square != .lightbulb && square != .mark { return false }
        
        let state = game[row, col].state
        if square.contains(.black) { return false }
        if state.contains(.black) { return false }
        
        return true
    }
    
    /// Plays a move in a given square.
    ///
    /// The grid flags are updated consequently after each move.
    /// - Parameters:
    ///   - row: Row index.
    ///   - col: Column index.
    ///   - square: The square value.
    /// - Precondition: `row` < ``numberOfRows``
    /// - Precondition: `col` < ``numberOfColumns``
    /// - Precondition: `square` must be either ``GameSquare/blank``, ``GameSquare/lightbulb`` or ``GameSquare/mark``
    /// - Precondition: The square at position (`row`, `col`) must not be a ``GameSquare/black`` square.
    public mutating func playMove(_ row: UInt, _ col: UInt, _ square: GameSquare) {
        guard checkMove(row, col, square) else { return }
        
        let currentState = game[row, col].state
        game[row, col] = square
        
        updateFlags()
        
        game.redo.removeAll()
        
        let move = GameMove(row, col, currentState, square)
        game.undo.prepend(move)
    }
    
    
    /// Update all grid flags.
    ///
    /// This is a low-level function, which is not intended to be used
    /// directly by end-user during the game.
    public mutating func updateFlags() {
        
        for i in rowRange {
            for j in columnRange {
                game[i, j] = game[i, j].state
            }
        }
        
        for i in rowRange {
            for j in columnRange {
                if game[i, j].state == .lightbulb { _update_lighted_flags(i, j) }
            }
        }
        
        for i in rowRange {
            for j in columnRange {
                if isLightbulb(i, j) && !_check_lightbulb_error(i, j) { game[i, j].insert(.error) }
                if isBlack(i, j) && !_check_black_wall_error(i, j) { game[i, j].insert(.error) }
            }
        }
    }
    
    
    /// Checks if the game is won.
    ///
    /// This function checks that all the game rules are satisfied,
    /// ie. that all the ``GameSquare/blank`` squares are ``GameSquare/lighted``, without any ``GameSquare/error``.
    /// - Returns: true if the game ended successfully, otherwise false
    public func isOver() -> Bool {
        for i in rowRange {
            for j in columnRange {
                if !isBlack(i, j) && !isLighted(i, j) { return false }
                if hasError(i, j) { return false }
            }
        }
        
        return true
    }
    
    
    /// Restarts a game.
    ///
    /// All the game is reset to its initial state. In particular, all the squares except
    /// ``GameSquare/black`` walls are reset to ``GameSquare/blank``, and all flags are cleared.
    public mutating func restart() {
        for i in rowRange {
            for j in columnRange {
                let state = game[i, j].state
                
                if state.contains(.black) { game[i, j] = state }
                else { game[i, j] = .blank }
            }
        }
        
        game.undo.removeAll()
        game.redo.removeAll()
    }
}

extension Game: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.game == rhs.game
    }
}


// MARK: - Game Aux

extension Game {
    
    /// Prints a as text on the standard output stream.
    ///
    /// The different squares are respectively displayed as text, based on a
    /// square-character mapping table.
    public func print() {
        var result = "   "
        for j in columnRange { result += "\(j)" }
        result += "\n"
        result += "   "
        for _ in columnRange { result += "_" }
        result += "\n"
        
        for i in rowRange {
            result += "\(i) |"
            for j in columnRange {
                let square = game[i, j]
                guard let string = square.toString() else { fatalError() }
                if string == "b" { result += " " }
                else { result += string }
            }
            result += "|\n"
        }
        result += "   "
        for _ in columnRange { result += "_" }
        Swift.print(result)
    }
    
    /// Creates the default game instance.
    ///
    /// See the description of the default game
    /// [here](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/lightup.html#7x7:b1f2iB2g1Bi2fBb)
    public static var `default` = Game(defaultSize, defaultSize, defaultGrid, false)
    
    /// Creates the default game solution instance.
    ///
    /// See the description of the default game
    /// [here](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/lightup.html#7x7:b1f2iB2g1Bi2fBb).
    public static var defaultSolution: Game {
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
        
        return game
    }
}


// MARK: - Game Ext

extension Game {
    
    /// Gets the number of rows (or height).
    public var numberOfRows: UInt { game.nb_rows }
    
    /// Gets the number of columns (or width).
    public var numberOfColumns: UInt { game.nb_cols }
    
    /// Checks if the game has the wrapping option.
    public var isWrapping: Bool { game.wrapping }
    
    /// Creates a new ``Game`` instance with extended options and initializes it.
    ///
    /// - Parameters:
    ///   - rows: Number of rows in game.
    ///   - cols: Number of columns in game.
    ///   - squares: An array describing the initial state of each square (row-major storage).
    ///   - wrapping: Wrapping option.
    /// - Returns: The new game instance
    public static func newExt(_ rows: UInt, _ cols: UInt, _ squares: [GameSquare], _ wrapping: Bool) -> Game {
        return self.init(rows, cols, squares, wrapping)
    }
    
    /// Creates a new empty game instance with extended options.
    ///
    /// All ``GameSquare`` are initialized with ``GameSquare/blank`` squares.
    /// - Parameters:
    ///   - rows: Number of rows in game.
    ///   - cols: number of columns in game.
    ///   - wrapping: Wrapping option.
    /// - Returns: The new ``Game`` instance.
    public static func newEmptyExt(_ rows: UInt, _ cols: UInt, _ wrapping: Bool) -> Game {
        let grid: [GameSquare] = Array(repeating: .blank, count: Int(rows * cols))
        return self.init(rows, cols, grid, wrapping)
    }
    
    /// Undoes the last move.
    ///
    /// Searches in the history the last move played (by calling
    /// ``playMove(_:_:_:)`` or ``redo()``),  and restores the state of the game
    /// before that move. If no moves have been played, this function does nothing.
    /// The ``restart()`` function clears the history.
    public mutating func undo() {
        guard let move = game.undo.popFirst() else { return }
        
        setSquare(move.row, move.column, move.old)
        updateFlags()
        
        game.redo.prepend(move)
    }
    
    /// Redoes the last move.
    ///
    /// Searches in the history the last cancelled move (by calling ``undo()``), and replays it.
    /// If there are no more moves to be replayed, this function does nothing.
    /// After playing a new move with ``playMove(_:_:_:)``, it is no longer possible to redo an old cancelled move.
    public mutating func redo() {
        guard let move = game.redo.popFirst() else { return }
        
        setSquare(move.row, move.column, move.new)
        updateFlags()
        
        game.undo.prepend(move)
    }
}


// MARK: - Game Tools

extension Game {
    
    /// Creates a game by loading its description from a json file.
    ///
    /// - Parameter filename: Input file (with no extension).
    /// - Returns: The loaded ``Game`` instance.
    public static func load(_ filename: String) -> Game {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        
        Swift.print(url.path)
        
        let file = filename + fileFormat
        let fileUrl = url.appendingPathComponent(folderName).appendingPathComponent(file)
        
        Swift.print(url.path)
        
        guard manager.fileExists(atPath: fileUrl.path) else { fatalError("File don't exist at \(fileUrl.path)") }
        guard let data = manager.contents(atPath: fileUrl.path) else { fatalError("Enable to get data from file \(fileUrl.path)") }
        
        let decoder = JSONDecoder()
        
        do {
            let format = try decoder.decode(JSONFormat.self, from: data)
            var game = self.init(format)
            game.updateFlags()
            return game
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Creates a game by loading its description from a json file.
    /// 
    /// - Parameters:
    ///   - bundel: The Bundel to refer
    ///   - filename: Input file.
    ///   - ext: File extension
    /// - Returns: The loaded ``Game`` instance.
    public static func load(from bundel: Bundle, _ filename: String, withExtension ext: String?) -> Game {
        let format = bundel.decode(JSONFormat.self, from: filename, withExtension: ext)
        
        var game = self.init(format)
        game.updateFlags()
        
        return game
    }
    
    /// Saves a game in a json file.
    ///
    /// - Parameter filename: Output file (with no extension).
    public func save(_ filename: String) {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        
        Swift.print(url.path)
        
        let folderUrl = url.appendingPathComponent(folderName)
        
        do {
            try manager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: [:])
        } catch {
            Swift.print(error)
        }
        
        let encoder = JSONEncoder()
        let format = JSONFormat(game)
        let file = filename + fileFormat
        let fileUrl = folderUrl.appendingPathComponent(file)
        
        do {
            let data = try encoder.encode(format)
            
            if manager.fileExists(atPath: fileUrl.path) {
                do { try manager.removeItem(at: fileUrl) }
                catch { Swift.print(error) }
            }
            
            guard manager.createFile(atPath: fileUrl.path, contents: data, attributes: [:]) else { fatalError("Can't create file \(fileUrl.path)") }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    public static func listOfFile() -> [String]? {
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let folderDirectory = documentDirectory.appendingPathComponent(folderName)
            
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: folderDirectory, includingPropertiesForKeys: nil)
            
            Swift.print("Folder path : \(folderDirectory)")

            for var url in directoryContents {
                url.hasHiddenExtension = true
            }
            
            let json = directoryContents.filter(\.isJSON).map { $0.localizedName ?? $0.lastPathComponent }
            
            return json
        } catch {
            Swift.print(error)
        }
        
        return nil
    }
    
    /// Computes the solution of a given ``Game``
    ///
    /// The game is updated with the first solution found. If there are
    /// no solution for this game, must be unchanged.
    /// - Returns: true of a solution is found, otherwise false.
    @discardableResult
    public mutating func solve() -> Bool {
        var nbSolution: UInt = 0
        var finish = false
        
        restart()
        
        _genAllSolution(0, game.squares.count, &finish, &nbSolution, true)
        
        return finish
    }
    
    /// Computes the total number of solutions of a given ``Game``.
    ///
    /// The game must be unchanged.
    /// - Returns: The number of solutions.
    public mutating func nbSolution() -> UInt {
        var copy = self
        var nbSolution: UInt = 0
        var finish = false
        
        copy.restart()
        
        copy._genAllSolution(0, copy.game.squares.count, &finish, &nbSolution, false)
        
        return nbSolution
    }
}


// MARK: - Private Methodes

extension Game {
    
    private mutating func _update_lighted_flags(_ row: UInt, _ col: UInt) {
        assert(row < game.nb_rows)
        assert(col < game.nb_cols)
        
        let state = game[row, col].state
        guard state == .lightbulb else { fatalError() }
        
        game[row, col].insert(.lighted)
        
        let startDir: GameDirection = .up
        let endDir: GameDirection = .right
        let dim = max(game.nb_rows, game.nb_cols)
        
        for dir in startDir.rawValue ... endDir.rawValue {
            var ii = Int(row)
            var jj = Int(col)
            
            for _ in 1 ..< dim {
                let cont = _next(&ii, &jj, GameDirection(rawValue: dir)!)
                
                if !cont { break }
                if game[ii, jj].state.contains(.black) { break }
                
                game[ii, jj].insert(.lighted)
            }
        }
    }
    
    private func _check_lightbulb_error(_ row: UInt, _ col: UInt) -> Bool {
        assert(row < game.nb_rows)
        assert(col < game.nb_cols)
        
        let dirs: [GameDirection] = [.up, .down, .left, .right]
        
        for dir in dirs {
            var ii = Int(row)
            var jj = Int(col)
            var dim: UInt = 0
            
            if dir == .up || dir == .down { dim = game.nb_rows }
            if dir == .left || dir == .right { dim = game.nb_cols }
            
            for _ in 1 ..< dim {
                let cont = _next(&ii, &jj, dir)
                
                if !cont { break }
                if game[ii, jj].state.contains(.black) { break }
                if game[ii, jj].state == .lightbulb { return false }
            }
        }
        
        return true
    }
    
    private func _check_black_wall_error(_ row: UInt, _ col: UInt) -> Bool {
        assert(row < game.nb_rows)
        assert(col < game.nb_cols)
        
        let state = game[row, col].state
        assert(state.contains(.black))
        
        if state == .blacku { return true }
        
        let expected = getBlackNumber(row, col)
        let nbLightbulbs = _neighCount(row, col, .lightbulb, .stateMask, false)
        let nbBlanks = _neighCount(row, col, .blank, .squareMask, false)
        
        if nbLightbulbs > expected { return false }
        if nbBlanks < (expected - Int(nbLightbulbs)) { return false }
        
        return true
    }
    
    /// Test if a given square is inside the board.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Returns: true if inside, otherwise false.
    private func _inside(_ row: Int, _ col: Int) -> Bool {
        var i = row
        var j = col
        if isWrapping {
            i = row / Int(game.nb_cols)
            j = col % Int(game.nb_cols)
        }
        
        if i < 0 || i >= game.nb_rows || j < 0 || j >= game.nb_cols { return false }
        
        return true
    }
    
    /// Test if the neighbour of a given square is inside the board.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - dir: The direction in wich to consider the neighbour.
    /// - Returns: true if inside, otherwise false.
    private func _insideNeigh(_ row: Int, _ col: Int, _ dir: GameDirection) -> Bool {
        return _inside(row + dir.iOffset, col + dir.jOffset)
    }
    
    /// Compute the next square coordinates in a given direction.
    ///
    /// If the next coordinates are out of board (return false), the
    /// coordinates of current square (*pi,*pj) are not updated. If the wrapping
    /// option is enabled, this function always returns true.
    ///
    /// - Parameters:
    ///   - pi: Address of current row index to be updated.
    ///   - pj: Address of current column index to be updated
    ///   - dir: The direction to consider.
    /// - Returns: true if the next cooardinate are inside the board, otherwise false.
    private func _next(_ pi: inout Int, _ pj: inout Int, _ dir: GameDirection) -> Bool {
        var i = pi
        var j = pj
        assert(i >= 0 && i < game.nb_rows && j >= 0 && j < game.nb_cols)
        
        i += dir.iOffset
        j += dir.jOffset
        
        if isWrapping {
            i = (i + Int(game.nb_rows)) % Int(game.nb_rows)
            j = (j + Int(game.nb_cols)) % Int(game.nb_cols)
        }
        
        if !_inside(i, j) { return false }
        
        pi = i
        pj = j
        return true
    }
    
    /// Test if a square has a given value.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value to be compared
    ///   - mask: A mask square to be applied before comparison.
    /// - Returns: true if equal, otherwise false.
    private func _test(_ row: Int, _ col: Int, _ square: GameSquare, _ mask: GameSquare) -> Bool {
        assert(square >= GameSquare._start && square < GameSquare._end)
        
        var i = row
        var j = col
        if isWrapping {
            i = (i + Int(game.nb_rows)) % Int(game.nb_rows)
            j = (j + Int(game.nb_cols)) % Int(game.nb_cols)
        }
        
        if !_inside(i, j) { return false }
        
        return game[i, j].intersection(mask) == square
    }
    
    /// Test if the neighbour square has a given value.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value to be compared
    ///   - mask: A mask square to be applied before comparison
    ///   - dir: The direction in which to consider the neighbour
    /// - Returns: true if equal, otherwise false.
    private func _testNeigh(_ row: Int, _ col: Int, _ square: GameSquare, _ mask: GameSquare, _ dir: GameDirection) -> Bool {
        return _test(row + dir.iOffset, col + dir.jOffset, square, mask)
    }
    
    /// Test if a square can be found in the neighbourhood of another
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value to look for
    ///   - mask: A mask square to be applied before comparison
    ///   - diag: Enable diagonal adjajency
    /// - Returns: true if found, otherwise false.
    private func _neigh(_ row: UInt, _ col: UInt, _ square: GameSquare, _ mask: GameSquare, _ diag: Bool) -> Bool {
        assert(square >= GameSquare._start && square < GameSquare._end)
        
        if _testNeigh(Int(row), Int(col), square, mask, .up) || _testNeigh(Int(row), Int(col), square, mask, .down) || _testNeigh(Int(row), Int(col), square, mask, .left) || _testNeigh(Int(row), Int(col), square, mask, .right) { return true }
        
        return diag && (_testNeigh(Int(row), Int(col), square, mask, .upLeft) || _testNeigh(Int(row), Int(col), square, mask, .upRight) || _testNeigh(Int(row), Int(col), square, mask, .downLeft) || _testNeigh(Int(row), Int(col), square, mask, .downRight))
    }
    
    /// Get the neighbourhood size.
    ///
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - diag: Enable diagonal adjacency
    /// - Returns: The neighbourhood size
    private func _neighSize(_ row: UInt, _ col: UInt, _ diag: Bool) -> UInt {
        return _neighCount(row, col, .blank, .blank, diag)
    }
    
    /// Tet the number of squares with a certain value in the neighbourhood of a given square
    /// 
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    ///   - square: The square value to look for
    ///   - mask: A mask square to be applied before comparison
    ///   - diag: Enable diagonal adjacency
    /// - Returns: The number of square found
    private func _neighCount(_ row: UInt, _ col: UInt, _ square: GameSquare, _ mask: GameSquare, _ diag: Bool) -> UInt {
        var count: UInt = _testNeigh(Int(row), Int(col), square, mask, .up).uintValue + _testNeigh(Int(row), Int(col), square, mask, .down).uintValue + _testNeigh(Int(row), Int(col), square, mask, .left).uintValue + _testNeigh(Int(row), Int(col), square, mask, .right).uintValue
        
        if diag {
            count += _testNeigh(Int(row), Int(col), square, mask, .upLeft).uintValue + _testNeigh(Int(row), Int(col), square, mask, .upRight).uintValue + _testNeigh(Int(row), Int(col), square, mask, .downLeft).uintValue + _testNeigh(Int(row), Int(col), square, mask, .downRight).uintValue
        }
        
        return count
    }
    
    private func _hasError() -> Bool {
        for i in rowRange {
            for j in columnRange {
                if hasError(i, j) { return true }
            }
        }
        
        return false
    }
    
    private mutating func _genAllSolution(_ pos: UInt, _ len: Int, _ finish: inout Bool, _ count: inout UInt, _ onlyOne: Bool) {
        if finish { return }
        
        if pos == len {
            if isOver() {
                count += 1
                if onlyOne { finish = true }
            }
            return
        }
        
        let row = pos / game.nb_cols
        let col = pos % game.nb_cols
        
        if finish { return }
        if !isBlack(row, col) && !isLighted(row, col) {
            playMove(row, col, .lightbulb)
            if !_hasError() {
                _genAllSolution(pos + 1, len, &finish, &count, onlyOne)
            }
        }
        
        if finish { return }
        if !isBlack(row, col) {
            playMove(row, col, .blank)
        }
        _genAllSolution(pos + 1, len, &finish, &count, onlyOne)
    }
}
