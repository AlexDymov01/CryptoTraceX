//
//  APIConstants.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 30.08.2023.
//

import Foundation

enum APIConstants {
    static let baseUrl: String = "https://api.coingecko.com"
    static let pathGlobalComponents: [String] = ["api", "v3", "global"]
    static let pathExchangesComponents: [String] = ["api", "v3", "exchanges"]
    static let pathCoinsComponents: [String] = ["api", "v3","coins", "markets"]
    static let pathTrendingComponents: [String] = ["api", "v3","search", "trending"]
    static let pathDetailedComponents: [String] = ["api", "v3", "coins"]
    static let coinListQueryParameters: [String : String] = [
        "vs_currency" : "usd",
        "order" : "market_cap_desc",
        "per_page" : "200",
        "page" : "1",
        "sparkline" : "false",
        "locale" : "en"
    ]
    static let exchangesQueryParameters : [String : String] = [
        "per_page" : "10"
    ]
    static let coinDetailInfoQueryParameters: [String : String] = [
        "localization" : "false",
        "tickers" : "false",
        "market_data" : "false",
        "community_data" : "false",
        "developer_data" : "false",
        "sparkline" : "false"
    ]
}

