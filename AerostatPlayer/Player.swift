//
//  PlayerViewModel.swift
//  AerostatSwiftUI
//
//  Created by Yuri Andrianov on 13.10.2022.
//

import AVKit
import SwiftUI
import MediaPlayer

class Player: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var maxDuration: Double = 0.0
    @Published var currentTime: Double = 0.0
    @Published var formattedMaxDuration: String = "--:--"
    @Published var formattedCurrentTime: String = "00:00"
    @Published var isPlaying: Bool = false
    @Published var podcastName: String = "777 - Example podcast name"
    @Published var trackName: String = "-"
    
    private var audioPlayer: AVAudioPlayer?
    
    init(trackName: String) {
        super.init()
        
        setupAudioSession()
        setupAudioPlayer(with: trackName)
        updateDurations()
        setupRemoteTransportControls()
        setupNowPlaying()
    }
    
    deinit {
        stop()
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
    }
    
    func setTime(from value: Double) {
        guard let time = TimeInterval(exactly: value) else {
            return
        }
        
        audioPlayer?.currentTime = time
    }
    
    func goForward() {
        guard let audioPlayer else {
            return
        }
        
        let newTime = audioPlayer.currentTime + 15
    
        audioPlayer.currentTime = newTime < audioPlayer.duration ? newTime : maxDuration
    }
    
    func goBackward() {
        guard let audioPlayer else {
            return
        }
        
        let newTime = audioPlayer.currentTime - 15
        
        audioPlayer.currentTime = newTime < 0.0 ? 0.0 : newTime
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        
        do{
            try session.setActive(true)
            try session.setCategory(.playAndRecord, mode: .default,  options: .defaultToSpeaker)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo: [String : Any] = [:]
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = trackName
        
        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = maxDuration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] event in
            self?.play()
            
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] event in
            self?.pause()
            
            return .success
        }
        
        commandCenter.seekForwardCommand.addTarget { [weak self] event in
            self?.goForward()
            
            return .success
        }
        
        commandCenter.seekBackwardCommand.addTarget { [weak self] event in
            self?.goBackward()
            
            return .success
        }
    }
    
    private func setupAudioPlayer(with fileName: String) {
        audioPlayer = nil
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Failed to find \(fileName) in bundle.")
            
            return
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            print("Failed to load \(fileName) from bundle.")
            
            return
        }
        
        audioPlayer = player
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        
        trackName = fileName
    }
    
    private func updateDurations() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        
        formattedMaxDuration = formatter.string(from: TimeInterval(self.audioPlayer?.duration ?? 0.0)) ?? "--:--"
        maxDuration = audioPlayer?.duration ?? 0.0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let audioPlayer = self?.audioPlayer else {
                return
            }
            
            if audioPlayer.isPlaying == false {
                self?.isPlaying = false
            }
            
            self?.currentTime = audioPlayer.currentTime
            self?.formattedCurrentTime = formatter.string(from: TimeInterval(audioPlayer.currentTime)) ?? "00:00"
        }
    }
}
