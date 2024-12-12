//
//  PingRepository.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/11/24.
//

import Combine
import Foundation


protocol PingRepository{
    
    func ping() -> AnyPublisher<Ping, Error>
}

final class RemotePingRepository: PingRepository{

    // MARK: - Injection
    init(session: HTTPClient = URLSession.shared) {
        self.client = session
    }
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private let client: HTTPClient

    // MARK: - Public
    func ping() -> AnyPublisher<Ping, Error>{

        print(PingProvider().urlString)
        return self.client
            .publisher(PingProvider().makeRequest)
            .tryMap(PingMapper.map)
            .eraseToAnyPublisher()
    }
}

struct PingMapper{
    
    struct InvalidJSONDecoder: Error {}

    static func map(data: Data, response: HTTPURLResponse) throws -> Ping{
        
        if response.statusCode == 200, let ping = try? JSONDecoder().decode(Ping.self, from: data){
            return ping
        }else{
            throw NetworkError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}
