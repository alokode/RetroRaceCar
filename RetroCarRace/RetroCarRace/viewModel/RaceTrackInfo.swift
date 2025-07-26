//
//  RaceTrackInfo.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import Foundation
import Combine

class RaceTrackInfo:ObservableObject{
    @Published var pause:Bool = false
    @Published var fastMode:Bool = false
    @Published var score:Int = 0
    @Published var highScore:Int =  UserDefaults.standard.value(forKey: "highScore") as? Int ?? 0 {
        didSet {
            UserDefaults.standard.setValue(highScore, forKey: "highScore")
        }
    }
    @Published var playerCarMovement:PlayerCarMovment = .none
    @Published var speed:Int = 1
    @Published var resetFlag:Bool = false
    @Published var isMute:Bool = false {
        didSet {
            MediaManager.shared.isMute = isMute
        }
    }
    
    func reset(){
        score = 0
        playerCarMovement = .none
        speed = 1
        resetFlag = true
        highScore = UserDefaults.standard.value(forKey: "highScore") as? Int ?? 0
    }
}
