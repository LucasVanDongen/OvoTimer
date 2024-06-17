// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum State: Equatable {
    case intro
    case winding(selectedTime: Ticks)
    case running(
        remainingTime: Ticks,
        selectedTime: Ticks
    )
    case paused(
        remainingTime: Ticks,
        selectedTime: Ticks
    )
    case finished(woundTime: Ticks)
}
