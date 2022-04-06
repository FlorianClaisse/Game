# Game

## New functions

```swift
Game.delete(_ filename: String) -> Game
Game.load(from bundel: Bundle, _ filename: String, withExtension ext: String?) -> Game
Game.listOfFile() -> [String]?
```

## File format

```json
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
```
