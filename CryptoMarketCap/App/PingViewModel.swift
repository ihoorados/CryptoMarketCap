//
//  PingViewModel.swift
//  CryptoMarketCap
//
//  Created by Hoorad on 12/12/24.
//

import Combine

enum PingState{
    
    case ready
    case loading
    case error
    case success
}

final class PingViewModel{
    
    private let service: RemotePingRepository
    private let coinService: RemoteCoinRepository

    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: PingState = .ready

    init(service: RemotePingRepository, coinService: RemoteCoinRepository) {
        
        self.service = service
        self.coinService = coinService
    }
    
    func tryPing(){
        
        self.state = .loading
        
        self.service.ping()
            .sink { [weak self] error in
                print(error)
                self?.state = .error
            } receiveValue: { [weak self] ping in
                print(ping)
                self?.state = .success
            }
            .store(in: &cancellables)
    }
    
    func tryCoins(){
        
        self.state = .loading
        
        self.coinService.coins()
            .sink { [weak self] error in
                print(error)
                self?.state = .error
            } receiveValue: { [weak self] ping in
                print(ping)
                self?.state = .success
            }
            .store(in: &cancellables)
    }
    
}
