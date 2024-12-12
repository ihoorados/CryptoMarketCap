//
//  NetworkError.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/11/24.
//


enum NetworkError: Error {
    
    case requestFailed
    case normalError(Error)
    case tokenExpired
    case emptyErrorWithStatusCode(String)

    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .normalError(let error):
            return error.localizedDescription
        case .tokenExpired:
            return "Token problems"
        case .emptyErrorWithStatusCode(let status):
            return status
        }
    }
}
