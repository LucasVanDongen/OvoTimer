// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct Counter: View {
    @State private var completion: CGFloat = 0.7

    private let width: CGFloat
    private let lineWidthRatio = 0.07

    public init(width: CGFloat) {
        self.width = width
    }

    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ZStack {
                Circle()
                    .trim(from: 0, to: completion)
                    .stroke(Color.ringRed, lineWidth: lineWidthRatio * width)
                Circle()
                    .trim(from: 0, to: completion)
                    .stroke(Color.ringWhite, lineWidth: lineWidthRatio * width)
                    .padding(lineWidthRatio * width)
            }
            .rotationEffect(.degrees(-90))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GeometryReader { geometry in
        Counter(width: geometry.size.width)
    }
}
