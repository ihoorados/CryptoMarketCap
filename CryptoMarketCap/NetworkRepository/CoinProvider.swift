//
//  CoinProvider.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/15/24.
//


import Foundation

struct CoinProvider: ApiEndpoint {

    var baseURLString: String {
        return "https://api.coingecko.com"
    }

    var apiPath: String {
        return "api"
    }

    var apiVersion: String? {
        return "v3"
    }

    var separatorPath: String? {
        nil
    }

    var path: String {
        return "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    }

    var headers: [String: String]? {

        return ["Content-Type": "application/json", "x-cg-demo-api-key" : "CG-tUohZZiV1CzqRaM4hcNR2aCc"]
    }

    var queryForCall: [URLQueryItem]? {
        return nil
    }

    var params: [String: Any]? {

        return nil
    }

    var method: ApiHTTPMethod {
        return .GET
    }

    var customDataBody: Data? {
        return nil
    }
}
