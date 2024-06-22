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
        guard
            let storeDate = initializationState.storeDate,
            !Self.`is`(
                storeDate: storeDate,
                staleComparedTo: currentDate
            )
        else {
            self = .intro
            return
        }

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
                .finished(woundTime: woundTime)
            case false:
                .running(remainingTime: 0, selectedTime: woundTime)
            }
        case let (.none, .some(woundTime), .some(pausedTime)):
            .paused(remainingTime: pausedTime, selectedTime: woundTime)
        case (.some, .none, .none), (.none, .some, .none), (.none, .none, .some), (.some, .none, .some), (.some, .some, .some):
            .intro // Illegal or unexpected state!
        }
    }

    static func `is`(
        storeDate: Date,
        staleComparedTo currentDate: Date
    ) -> Bool {
        // We don't need to use Calendar here because the exact amount of hours is not so relevant
        let hours: TimeInterval = 8 * 60 * 60

        return currentDate.timeIntervalSince(storeDate) > hours
    }
}
