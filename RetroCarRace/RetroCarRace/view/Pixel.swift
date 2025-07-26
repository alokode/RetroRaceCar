//
//  Pixel.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

let screenBackground = Color(red: 169 / 255, green: 183 / 255, blue: 172 / 255)
struct Pixel: View {
    var rectSize:CGFloat = 100.0
    var isActive:Bool = true
    var mainRectBackgroundColor:Color {
        return screenBackground
    }
    var borderColor:Color {
        return isActive ? .black : .gray.opacity(0.8)
    }
    var innerRectangleFill:Color {
        return isActive ? .black : .gray.opacity(0.8)
    }
    var body: some View {
        ZStack{
            Rectangle()
                .fill(mainRectBackgroundColor)
                .frame(width: rectSize,height: rectSize, alignment: .center)
                .border(borderColor, width: rectSize/6)
                
            Rectangle()
                .fill(innerRectangleFill)
                .frame(width: rectSize/2.7,height: rectSize/2.7, alignment: .center)
        }.frame(width: rectSize,height: rectSize)
    }
}

#Preview {
    Pixel()
}
