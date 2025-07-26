//
//  ControllButtons.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

struct ControllButton: View {
    var buttonText:String = "Text"
    var buttonColor:Color = .yellow
    var action: () -> Void
    
    var body: some View {
        VStack{
            Button(action: action, label: {
                VStack {
                    Circle()
                        .fill((RadialGradient(gradient: Gradient(colors: [Color.yellow, Color.black]),
                                                  center: .center, startRadius: 100, endRadius: 500)))
                    Text(buttonText)
                        .foregroundStyle(.yellow)
                }
            })
            
        }
    }
}

#Preview {
    ControllButton( action: {
        
    })
}
