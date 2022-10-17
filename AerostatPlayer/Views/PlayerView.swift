//
//  PlayerView.swift
//  AerostatSwiftUI
//
//  Created by Yuri Andrianov on 13.10.2022.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    @ObservedObject var player: Player
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                TappableSlider(
                    value: Binding(
                        get: { player.currentTime },
                        set: { value in player.setTime(from: value) }
                    ),
                    range: 0...player.maxDuration
                )
                .frame(height: 20)
                .accentColor(.orange)
                
                VStack(spacing: 8) {
                    Text(player.podcastName)
                        .font(Font.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                    
                    Text(player.trackName)
                        .font(Font.system(size: 16, weight: .medium))
                        .foregroundColor(Color("GrayA"))
                        .lineLimit(1)
                }
                .frame(height: 40)
                
                HStack {
                    Text(player.formattedCurrentTime)
                        .font(Font.system(size: 16, weight: .medium).monospacedDigit())
                        .foregroundColor(Color("GrayA"))
                    
                    Spacer()
                    
                    Button {
                        player.goBackward()
                    } label: {
                        Image(systemName: "gobackward.15")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("GrayA"))
                    }
                    
                    Spacer()
                    
                    Button {
                        player.isPlaying ? player.pause() : player.play()
                    } label: {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        player.goForward()
                    } label: {
                        Image(systemName: "goforward.15")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("GrayA"))
                    }
                    
                    Spacer()
                    
                    Text(player.formattedMaxDuration)
                        .font(Font.system(size: 16, weight: .medium).monospacedDigit())
                        .foregroundColor(Color("GrayA"))
                }
                .frame(height: 40)
            }
            .padding()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerView(player: Player(trackName: "DMX - Party up.mp3"))
    }
}
