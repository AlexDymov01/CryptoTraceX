//
//  OverviewModel.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

// MARK: - OverviewTableViewCoin

struct OverviewTableViewCoin: Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCapRank : Int
    let priceChangePercentage24h : Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}

// MARK: - OverviewCollectionViewExchange

struct OverviewCollectionViewExchange: Codable {
    let id, name: String
    let url: String
    let image: String
    let trustScore: Int
    let tradeVolume24HBtc: Double

    enum CodingKeys: String, CodingKey {
        case id, name
        case url, image
        case trustScore = "trust_score"
        case tradeVolume24HBtc = "trade_volume_24h_btc"
    }
}

// MARK: - OverviewGlobalData

struct OverviewGlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
}
