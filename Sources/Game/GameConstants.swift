//
//  GameConstant.swift
//  
//
//  Created by Florian Claisse on 28/01/2022.
//

/// Size of the default game grid.
public let defaultSize: UInt = 7

/// Maximum number of rows or columns
public let maxSize: UInt = 10

/// Minimum number of rows or columns
public let minSize: UInt = 1

internal let defaultGrid: [GameSquare] = [
    .blank, .blank, .black1, .blank, .blank, .blank, .blank,
    .blank, .blank, .black2, .blank, .blank, .blank, .blank,
    .blank, .blank, .blank, .blank, .blank, .blacku, .black2,
    .blank, .blank, .blank, .blank, .blank, .blank, .blank,
    .black1, .blacku, .blank, .blank, .blank, .blank, .blank,
    .blank, .blank, .blank, .blank, .black2, .blank, .blank,
    .blank, .blank, .blank, .blank, .blacku, .blank, .blank,
]

internal let folderName = "LightUp_Saved"
internal let fileFormat = ".json"
