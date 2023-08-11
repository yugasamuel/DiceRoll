//
//  SavedData.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import Foundation

struct SavedData: Codable {
    let results: [Int]
    let rollResult: Int
    let totalResult: Int
    let totalSide: Int
}
