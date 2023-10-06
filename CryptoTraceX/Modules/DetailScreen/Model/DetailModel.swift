//
//  DetailModel.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

// MARK: - CoinDetailModel

struct CoinDetailModel: Codable {
    let name: String
    let description: Description
    let links: Links
    let image: Image
    let marketCapRank : Int
    let marketData: MarketData
    
    enum CodingKeys: String, CodingKey {
        case name
        case description, links, image
        case marketCapRank = "market_cap_rank"
        case marketData = "market_data"
    }
}

// MARK: - Description

struct Description: Codable {
    let en : String
}

// MARK: - Links

struct Links: Codable {
    let homepage: [String]
}

// MARK: - MarketData

struct MarketData: Codable {
    let currentPrice: [String: Double]
    let athChangePercentage: [String: Double]
    let marketCap: [String: Double]
    let marketCapRank: Int
    let totalVolume, high24H, low24H: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case athChangePercentage = "ath_change_percentage"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
    }
}

struct Image: Codable {
    let thumb, small, large: String
}
