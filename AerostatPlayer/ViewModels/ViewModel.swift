//
//  ViewModel.swift
//  AerostatPlayer
//
//  Created by Yuri Andrianov on 17.10.2022.
//

import Combine

final class ViewModel: ObservableObject {
    
    @Published var tracks: [Track] = [
        Track(name: "СЛОТ - Москва.mp3"),
        Track(name: "DMX - Party up.mp3"),
        Track(name: "Modern Talking - You're my heart you're my soul.mp3"),
        Track(name: "MC Hammer - U can't touch this.mp3"),
        Track(name: "Enya - Only time.mp3"),
        Track(name: "Adriano Celentano - I love you baby.mp3")
    ]
}
