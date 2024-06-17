//
//  ContentView.swift
//  OvoTimer
//
//  Created by Lucas van Dongen on 12/06/2024.
//

import SwiftUI
import Winder

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Counter(width: geometry.size.width * 0.83)
                    .padding(geometry.size.width * 0.17)
                Winder(
                    width: geometry.size.width,
                    viewModel: WinderViewModel()
                )
            }
            .background(.black)
        }
        .frame(
            minWidth: 200,
            maxWidth: 650,
            minHeight: 200,
            maxHeight: 650,
            alignment: .center
        )
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview(traits: .portrait) {
    ContentView()
}
