//
//  ControllsView.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

struct ControllsView: View {
    @ObservedObject  var raceTrackInfo:RaceTrackInfo
    var controllButtonSize : CGFloat = 80.0
    var body: some View {
        VStack(spacing:0){
            HStack {
                ControllButton(buttonText: "Fast", action: {
                    
                    })
                    .frame(width: controllButtonSize,height: controllButtonSize)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !raceTrackInfo.fastMode {
                                    raceTrackInfo.fastMode = true
                                    ////print("#ALK press start")
                                }
                            }
                            .onEnded { _ in
                                if raceTrackInfo.fastMode {
                                    ////print("#ALK press end")
                                    raceTrackInfo.fastMode = false
                                }
                            }
                    )
                ControllButton(buttonText: "Reset", action: {
                    MediaManager.shared.playSound(type: .reset)
                    raceTrackInfo.reset()
                    })
                    .frame(width: controllButtonSize,height: controllButtonSize)
                ControllButton(buttonText: "Pause", action: {
                    MediaManager.shared.playSound(type: .pause)
                    raceTrackInfo.pause =  !raceTrackInfo.pause
                    })
                    .frame(width: controllButtonSize,height: controllButtonSize)
                ControllButton(buttonText: "Sound", action: {
                    raceTrackInfo.isMute = !raceTrackInfo.isMute
                    })
                    .frame(width: controllButtonSize,height: controllButtonSize)
            }
            .padding(.bottom)
            
            HStack(spacing:25) {
                
                
                Button(action: {
                    MediaManager.shared.playSound(type: .playerMove)
                    raceTrackInfo.playerCarMovement = .left
                }, label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .tint(RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.black]),
                                             center: .center, startRadius: 20, endRadius: 200))
                })
                
                Button(action: {
                    MediaManager.shared.playSound(type: .playerMove)
                    raceTrackInfo.playerCarMovement = .right
                }, label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .tint(RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.black]),
                                             center: .center, startRadius: 20, endRadius: 200))
                })
            }
        }.background(.black)
            .frame(alignment: .center)
            
    }
}

#Preview {
    ControllsView(raceTrackInfo: RaceTrackInfo())
}


/*   Button(action: {
        ////print("#ALK MOVE LEFT")
       raceTrackInfo.pause =  !raceTrackInfo.pause
    }) {
        Text("Pause")
    }
   
   
   Button(action: {
       ////print("#ALK MOVE LEFT")
       raceTrackInfo.playerCarMovement = .left
   }) {
       Text("Left")
   }
   
   
   Button(action: {
       ////print("#ALK MOVE RIGHT")
       raceTrackInfo.playerCarMovement = .right
   }) {
       Text("Right")
   }
   
   
   
   
   
   Button(action: {
       ////print("Button tapped")
   }) {
       Text("FAST")
   }
   .simultaneousGesture(
       DragGesture(minimumDistance: 0)
           .onChanged { _ in
               if !raceTrackInfo.fastMode {
                   raceTrackInfo.fastMode = true
                   ////print("#ALK press start")
               }
           }
           .onEnded { _ in
               if raceTrackInfo.fastMode {
                   ////print("#ALK press end")
                   raceTrackInfo.fastMode = false
               }
           }
   )*/
