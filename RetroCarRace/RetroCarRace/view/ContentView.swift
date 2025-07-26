//
//  ContentView.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var raceTrackInfo = RaceTrackInfo()
    @State  var pressingFastButton = false
    @State  var pasueButton = false
    @State var playerCarMovment:PlayerCarMovment = .none
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let totalHeight = geometry.size.height
            VStack(spacing:0) {
                ConsoleTopView()
                HStack(alignment:.top,spacing:0) {
                    RaceTrack(raceTrackInfo: raceTrackInfo)
                        .frame(width: totalWidth * 0.70,height: totalHeight*0.60).clipped()
                        .contentMargins(0)
                        .border(.black,width: 4)
                    ScoreBoard(raceTrackInfo: raceTrackInfo)
                        .frame(height: totalHeight*0.60).clipped()
                        .contentMargins(0)
                        .clipped()
                        .border(.black,width: 4)
                }
                .clipped()
                .frame(height:totalHeight*0.60,alignment: .top)
                .border(.blue, width: 0)
                ControllsView(raceTrackInfo: raceTrackInfo)
                    .frame(maxHeight: .infinity)
                    .padding(.top)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                Spacer()
                ConsoleBottomView()
                
            }
            
            .frame(maxWidth:.infinity,alignment: .top)
            .background(.black)
            Spacer()
            
           
        }
    }
}
#Preview {
    ContentView()
}

struct ConsoleTopView: View {
    var body: some View {
        HStack {
            ForEach(0...5,id:\.self) {_ in
                Circle()
                    .fill(.yellow)
            }
            
        }.frame(width: 100)
            .padding(.bottom)
    }
}

struct ConsoleBottomView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(.red)
            Circle()
                .fill(.red)
            Circle()
                .fill(.red)
            Circle()
                .fill(.red)
            Rectangle()
                .fill(.red)
        }.frame(height: 5)
    }
}
