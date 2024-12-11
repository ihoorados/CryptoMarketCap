//
//  NetworkSession.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/11/24.
//

import Foundation
import Combine

protocol NetworkSession: AnyObject {
    func publisher<T>(_ request: URLRequest, decodingType: T.Type) -> AnyPublisher<T, NetworkError> where T: Decodable
}

protocol HTTPClient {
    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}

extension URLSession: HTTPClient{

    struct InvalidHTTPResponseError: Error {}

    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap({ result in

                guard let httpResponse = result.response as? HTTPURLResponse else {

                    throw InvalidHTTPResponseError()
                }
                return (result.data, httpResponse)
            })
            .eraseToAnyPublisher()
    }
}
