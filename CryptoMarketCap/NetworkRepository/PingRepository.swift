//
//  PingRepository.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/11/24.
//

import Combine
import Foundation

class PingRepository: ObservableObject{

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var request: ApiEndpoint
    private let client: HTTPClient

    // MARK: - Published
    @Published var api: ApiEndpoint
    @Published var data: Data? = nil
    @Published var httpURLResponse: HTTPURLResponse? = nil
    @Published var responseString: String? = nil

    // MARK: - Injection
    init(session: HTTPClient = URLSession.shared, request: ApiEndpoint) {

        self.request = request
        self.client = session
        self.api = request
    }

    // MARK: - Public
    func performRequest() -> AnyPublisher<(Data, HTTPURLResponse), any Error>{

        self.httpURLResponse = nil
        self.data = nil
        self.responseString = nil

        self.client.publisher(self.request.makeRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in

                print("receiveCompletion: \(error)")

            }, receiveValue: { result in

                self.httpURLResponse = result.1
                print(result.1.allHeaderFields)
                print(result.1.statusCode)
                self.state = .response

                self.data = result.0
                do{

                    if let string = String(data: result.0, encoding: .utf8){

                        self.responseString = string
                    }
                    if let searchString = SearchProvider.decode(data: result.0 as NSData){

                        self.responseString = searchString.description
                    }
                    if let json = try JSONSerialization.jsonObject(with: result.0, options: []) as? [String : Any]{
                        self.responseString = json.description
                    }

                }
                catch{}
            })
            .store(in: &cancellables)
    }
    
}
