//
//  CoinRepository.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/15/24.
//



import Combine
import Foundation

protocol CoinRepository{
    
    func coins() -> AnyPublisher<Coin, Error>
}

final class RemoteCoinRepository: CoinRepository{

    // MARK: - Injection
    init(session: HTTPClient = URLSession.shared) {
        self.client = session
    }
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private let client: HTTPClient

    // MARK: - Public
    func coins() -> AnyPublisher<Coin, Error>{

        print(CoinProvider().urlString)
        return self.client
            .publisher(CoinProvider().makeRequest)
            .tryMap(CoinMapper.map)
            .eraseToAnyPublisher()
    }
}

struct CoinMapper{
    
    struct InvalidJSONDecoder: Error {}

    static func map(data: Data, response: HTTPURLResponse) throws -> Coin{
        
        if response.statusCode == 200, let ping = try? JSONDecoder().decode(Coin.self, from: data){
            return ping
        }else{
            throw NetworkError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}
