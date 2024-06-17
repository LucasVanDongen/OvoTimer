//
//  SpiralCalculator.swift
//  
//
//  Created by Lucas van Dongen on 17/06/2024.
//

import Foundation

public struct SpiralCalculator {
    public func spiral(t: Double) -> (Double, Double) {
        let a: CGFloat = 0.1
        let b: CGFloat = 0.1
        let r = a + b * t
        let x = r * cos(t)
        let y = r * sin(t)

        return (x, y)
    }
}
