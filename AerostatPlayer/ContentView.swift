//
//  ContentView.swift
//  AerostatPlayer
//
//  Created by Yuri Andrianov on 16.10.2022.
//

import SwiftUI

struct Track: Identifiable {
    
    var id = UUID()
    let name: String
}

class ViewModel: ObservableObject {
    
    @Published var tracks: [Track] = [
        Track(name: "СЛОТ - Москва.mp3"),
        Track(name: "DMX - Party up.mp3"),
        Track(name: "Modern Talking - You're my heart you're my soul.mp3"),
        Track(name: "MC Hammer - U can't touch this.mp3"),
        Track(name: "Enya - Only time.mp3"),
        Track(name: "Adriano Celentano - I love you baby.mp3")
    ]
}

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
