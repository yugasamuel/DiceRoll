//
//  FileManager-DocumentsDirectory.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
