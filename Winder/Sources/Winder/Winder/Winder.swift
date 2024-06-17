//
//  Winder.swift
//
//
//  Created by Lucas van Dongen on 12/06/2024.
//

import Charts
import SwiftUI

// Read the comments in `LinePlot` below for an explication
fileprivate let spiralCalculator = SpiralCalculator()

public struct Winder: View {
    public let viewModel: WinderViewModelImplementing

    private let width: CGFloat

    public init(
        width: CGFloat,
        viewModel: WinderViewModelImplementing
    ) {
        self.width = width
        self.viewModel = viewModel
    }

    public var body: some View {
        Chart(viewModel.points) {
            LinePlot(
                x: "x",
                y: "y",
                t: "t",
                domain: viewModel.beginAngle...viewModel.endAngle
            ) { t in
                // There's a special issue here that I don't know how to deal with yet
                // This function (probably for good reasons) is synced to the MainActor
                // So it's really hard to call anything outside of it if you want to share the mathematical function!
                // That doesn't stop it from calling this function on the Main thread anyway 🤷‍♂️
                spiralCalculator.spiral(t: t)
            }

            PointMark(
                x: .value("Wing Length", $0.x),
                y: .value("Wing Width", $0.y)
            ).symbol {
                Circle()
                    .fill(.clear)
                    .stroke(
                        .white,
                        lineWidth: 2
                    )
                    .frame(
                        width: 8,
                        height: 8
                    )
            }
        }
        .chartXScale(domain: -8...8)
        .chartYScale(domain: -8...8)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .aspectRatio(
            1,
            contentMode: .fit
        )
        .foregroundColor(.white)
    }
}

#Preview {
    @Previewable @State var viewModel = WinderViewModel()

    VStack(alignment: .leading) {
        Text("Start").padding()
        Slider(value: $viewModel.beginAngle, in: viewModel.minimumAngle...viewModel.endAngle)
            .onChange(of: viewModel.beginAngle) { _, newValue in
                viewModel.updateBeginPoint(to: newValue)
            }
            .onChange(of: viewModel.endAngle) { _, newValue in
                viewModel.updateEndPoint(to: newValue)
            }
            .padding()

        Text("End").padding()
        Slider(
            value: $viewModel.endAngle,
            in: viewModel.beginAngle...viewModel.maximumAngle
        )
        .onChange(of: viewModel.endAngle) { _, newValue in
            viewModel.updateEndPoint(to: newValue)
        }
        .padding()

        GeometryReader { geometry in
            Winder(
                width: geometry.size.width,
                viewModel: viewModel
            )
        }
    }.background(.gray)
}
