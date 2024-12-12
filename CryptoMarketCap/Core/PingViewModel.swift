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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: PingState = .ready

    init(service: RemotePingRepository) {
        self.service = service
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
    
}
