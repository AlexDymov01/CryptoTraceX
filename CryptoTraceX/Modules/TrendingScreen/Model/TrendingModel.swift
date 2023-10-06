//
//  TrendingModel.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

// MARK: - TrendingModel

struct TrendingModel: Codable {
    let coins: [Coin]
}

// MARK: - Coin

struct Coin: Codable {
    let item: Item?
}

// MARK: - Item

struct Item: Codable {
    let id: String
    let name : String
    let large: String

    enum CodingKeys: String, CodingKey {
        case id, name, large
    }
}

