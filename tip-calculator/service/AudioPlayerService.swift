//
//  AudioPlayerService.swift
//  tip-calculator
//
//  Created by Soroush on 8/15/23.
//

import Foundation
import AVFoundation

// create an av audio player
// we want create an audio player to inject in view model. this is useful for unit test.

// we are wrapping this inside a protocol. so we can do dependency injection as well as unit test to facilitate unit test.

protocol AudioPlayerService {
    func playSound()
}

// implementation of this audio player
// we use final for optimizing the performance
final class DefaultAudioPlayer: AudioPlayerService {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        
        // to play sound, we have to create instance of AV Audio player and we can reference this.
        
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let error) {
            print("error", error.localizedDescription)
        }
    }
}


