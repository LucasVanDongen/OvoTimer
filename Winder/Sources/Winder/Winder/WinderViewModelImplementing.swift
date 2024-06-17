//
//  CounterWinding.swift
//  
//
//  Created by Lucas van Dongen on 17/06/2024.
//

import Foundation

@MainActor
public protocol WinderViewModelImplementing {
    var minimumAngle: CGFloat { get }
    var maximumAngle: CGFloat { get}
    var beginAngle: CGFloat { get }
    var endAngle: CGFloat { get }

    var points: [PlotPoint] { get }
}
