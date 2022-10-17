//
//  ContentView.swift
//  AerostatPlayer
//
//  Created by Yuri Andrianov on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    @State private var trackName = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    List(viewModel.tracks) { track in
                        HStack(spacing: 20) {
                            Image(systemName: "music.mic.circle")
                                .resizable()
                                .foregroundColor(.orange)
                                .frame(width: 30, height: 30)
                            
                            Text(track.name)
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            trackName = track.name
                        }
                    }
                    .listStyle(.plain)
                    
                    PlayerView(player: Player(trackName: trackName))
                        .frame(height: geometry.size.height / 4.5)
                }
            }
            .padding()
            .navigationTitle(Text("Tracks"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
