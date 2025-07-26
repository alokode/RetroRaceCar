//
//  TestingView.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
        VStack {
            HStack(spacing:0){
                Text("Score")
                    .background(Color.blue)
                Text("Score")
                    .background(Color.red)
            }
        }
    }
}

#Preview {
    TestingView()
}
