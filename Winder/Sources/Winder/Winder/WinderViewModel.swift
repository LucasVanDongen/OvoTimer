//
//  CounterWinder.swift
//  
//
//  Created by Lucas van Dongen on 17/06/2024.
//

import Foundation

@Observable
@MainActor
public class WinderViewModel: WinderViewModelImplementing {
    public let minimumAngle: CGFloat = 60
    public let maximumAngle: CGFloat = 75
    public var beginAngle: CGFloat = 60
    public var endAngle: CGFloat = 75

    private let spiralCalculator = SpiralCalculator()

    private(set) public var points: [PlotPoint] = [
        PlotPoint(
            id: 1,
            x: 0,
            y: 0
        ),
        PlotPoint(
            id: 2,
            x: 1,
            y: 3
        )
    ]

    public init() {
        updateBeginPoint(to: beginAngle)
        updateEndPoint(to: endAngle)
    }

    public func updateBeginPoint(to newValue: Double) {
        let endPoint = spiralCalculator.spiral(t: newValue)

        points[0] = PlotPoint(
            id: 2,
            x: endPoint.0,
            y: endPoint.1
        )
    }

    public func updateEndPoint(to newValue: Double) {
        let endPoint = spiralCalculator.spiral(t: newValue)

        points[1] = PlotPoint(
            id: 2,
            x: endPoint.0,
            y: endPoint.1
        )
    }
}
