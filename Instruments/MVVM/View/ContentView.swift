//
//  ContentView.swift
//  Instruments
//
//  Created by Anurag on 28/08/26.
//

import SwiftUI

struct ContentView: View {
    
    let coins = (1...1000).map { Coin(url: "https://picsum.photos/id/\($0)/200/200")
    }

    
    var body: some View {
        ScrollView {
            //Memmory Allocation Instrument: Time Profiling
            // Try VStack first (heavy)
            //Useful to show how stacks increases rendering overhead.
            
            //As it load all the image at once
//            VStack {
//                ForEach(coins) { coin in
//                    CoinImageView(url: coin.url)
//                }
//            }
            
            //Useful to show how lazy stacks reduce rendering overhead.
            // Optimized LazyVStack
            LazyVStack {
                ForEach(coins) { coin in
                    CoinImageView(url: coin.url)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}


struct CoinImageView: View {
    
    @StateObject private var vm = CoinImageViewModel()
    
    let url: String
    
    var body: some View {
        Group {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            vm.loadImage(from: url)
        }
    }
}
