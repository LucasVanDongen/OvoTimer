//
//  State+Initialization.swift
//
//
//  Created by Lucas van Dongen on 14/06/2024.
//

import Foundation

extension State {
    init(
        initializationState: InitializationState,
        currentDate: Date
    ) {
        self = switch (
            initializationState.endDate,
            initializationState.woundTime,
            initializationState.pausedTime
        ) {
        case (.none, .none, .none):
                .intro
        case let (.some(endDate), .some(woundTime), .none):
            switch endDate <= currentDate {
            case true:
                //if endDate < someVery
                    .finished(woundTime: woundTime)
            case false:
                // TODO: calculate remaining time
                    .running(remainingTime: 0, selectedTime: woundTime)
            }
        case let (.none, .some(woundTime), .some(pausedTime)):
                .paused(remainingTime: pausedTime, selectedTime: woundTime)
        case (.some, .none, .none), (.none, .some, .none), (.none, .none, .some), (.some, .none, .some), (.some, .some, .some):
                .intro // Illegal state!
        }
    }
}
