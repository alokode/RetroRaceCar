//
//  ScoreBoard.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

struct ScoreBoard: View {
    @ObservedObject var raceTrackInfo:RaceTrackInfo
    var body: some View {
        VStack(alignment:.center) {
            Spacer()
            Text("Score").frame(maxWidth:.infinity)
                .font(.title3)
                .foregroundColor(.black)
                .bold()
            Text("\(raceTrackInfo.score)")
                .frame(maxWidth:.infinity)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
                .bold()
                .padding(.bottom)
           
            Text("High Score")
                .frame(maxWidth:.infinity)
                .font(.title3)
                .foregroundColor(.black)
                .bold()
            Text("\(raceTrackInfo.highScore)")
                .frame(maxWidth:.infinity)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
                .bold()
                .padding(.bottom)
            
            Text("Speed")
                .frame(maxWidth:.infinity)
                .font(.title3)
                .foregroundColor(.black)
                .bold()
            Text("\(raceTrackInfo.speed)")
                .frame(maxWidth:.infinity)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
                .bold()
                .padding(.bottom)
            Image(systemName: (raceTrackInfo.isMute ? "speaker.slash.fill" : "speaker.wave.2.fill") )
                .resizable()
                .frame(width: 30,height: 30)
                .foregroundColor(.black)
            Spacer()
            
        }.frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
        .background(screenBackground)
        .padding(0)
        .onChange(of: raceTrackInfo.score) {
            
        }
        
    }
}

#Preview {
    @StateObject var raceTrackInfo = RaceTrackInfo()
    return ScoreBoard(raceTrackInfo: raceTrackInfo)
}
