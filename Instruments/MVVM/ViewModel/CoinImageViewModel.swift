//
//  CoinImageViewModel.swift
//  Instruments
//
//  Created by Anurag on 28/08/26.
//

import UIKit
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager()
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        networkManager.downloadData(url: url)
            .map { UIImage(data: $0) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error): print("Error: \(error)")
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables)
    }
}
