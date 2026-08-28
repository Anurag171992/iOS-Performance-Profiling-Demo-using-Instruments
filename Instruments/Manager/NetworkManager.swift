//
//  NetworkManager.swift
//  Instruments
//
//  Created by Anurag on 28/08/26.
//

import Foundation
import Combine

class NetworkManager {
    private let session: URLSession
    
    //Memmory Instrument: Perfect to prove that caching prevents repeated image allocations. memory allocations and leaks.
    //Network Instrument: Lets you prove that URLCache reduces redundant calls when scrolling back.
    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, // 50 MB RAM
            diskCapacity: 200 * 1024 * 1024,  // 200 MB disk
            diskPath: "imageCache"
        )
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func downloadData(url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .retry(2)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
