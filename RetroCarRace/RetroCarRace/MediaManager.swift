//
//  MediaManager.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 07/08/24.
//

import Foundation
import AVKit

enum SoundType {
    case reset,collision,speedup,playerMove,pause
}
class MediaManager {
    static var shared = MediaManager()
    var isMute:Bool = false
    private var player: AVAudioPlayer?
    
    private func playSound(file: String, type: String) {
        if let path = Bundle.main.path(forResource: file, ofType: type) {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.play()
            } catch {
                //print("Error: Could not find and play the sound file.")
            }
        }
    }
    
    func playSound(type:SoundType){
        if !isMute {
            var fileName = ""
            switch type {
            case .reset:
                fileName = "reset"
            case .collision:
                fileName = "explosion"
            case .speedup:
                fileName = "speed_change"
            case .playerMove:
                fileName = "player_move"
            case .pause:
                fileName  = "play_pause"
            }
            playSound(file: fileName, type: "wav")
        }
        
    }
}
