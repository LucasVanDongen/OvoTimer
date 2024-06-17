//
//  Model.swift
//  
//
//  Created by Lucas van Dongen on 14/06/2024.
//

import Foundation

public protocol ModelImplementing {
    var state: State { get }
}

// @Observable
public class Model {
    private(set) public var state: State

    init(state: State) {
        self.state = state
    }

    func wind(to ticks: Ticks) {
        guard
            ticks >= 0
        else {
            return
        }

        state = .winding(selectedTime: ticks)
    }

    func start() {
        switch state {
        case let .finished(timeToCount), let .winding(timeToCount):
            state = .running(
                remainingTime: timeToCount,
                selectedTime: timeToCount
            )
        case .intro, .running, .paused:
             break
        }
    }

    func restart() {
        switch state {
        case let .finished(woundTime):
            state = .running(remainingTime: woundTime, selectedTime: woundTime)
        case .intro, .paused, .running, .winding:
            break
        }
    }

    func pause() {
        switch state {
        case let .running(remainingTime, selectedTime):
            state = .paused(remainingTime: remainingTime, selectedTime: selectedTime)
        case .intro, .winding, .paused, .finished:
            break
        }
    }

    func unpause() {
        switch state {
        case let .paused(remainingTime, selectedTime):
            state = .running(remainingTime: remainingTime, selectedTime: selectedTime)
        case .intro, .winding, .running, .finished:
            break
        }
    }

    func tick() {
        switch state {
        case let .running(previousRemainingTime, selectedTime):
            let remainingTime = previousRemainingTime - 1
            state = switch remainingTime == 0 {
            case true: .finished(woundTime: selectedTime)
            case false: .running(remainingTime: remainingTime, selectedTime: selectedTime)
            }
        case .intro, .winding, .paused, .finished:
            break
        }
    }
}
