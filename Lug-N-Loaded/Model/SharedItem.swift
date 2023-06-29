//
//  SharedItem.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import Foundation

struct SharedItem: Codable {
    var itemId: Int
    var positionX: Double
    var positionY: Double
    var inLuggage: Bool
    var itemRotation: Int
    var inPlayer1: Bool
    var inPlayer2: Bool
}
