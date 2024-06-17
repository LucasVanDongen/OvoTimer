//
//  Ticks.swift
//
//
//  Created by Lucas van Dongen on 14/06/2024.
//

import Foundation

/**
 `Ticks` is an abstraction for one "tick" (second) in the system.

 The actual type is hidden behind a `typealias` so it can easily be switched between different kinds of values, like:

 * `Int`
 * `Double`
 * `TimeInterval`
*/
public typealias Ticks = Int
