//
//  InitializationTests.swift
//
//
//  Created by Lucas van Dongen on 13/06/2024.
//

import Foundation
import Testing

@testable import Model

@Suite
struct InitializationTests {
    private let woundTime: Ticks = 500
    private let pausedTime: Ticks = 123
    private let currentDate: Date
    private let nearFutureDate: Date
    private let nearPastDate: Date
    private let longPastDate: Date

    init() {
        currentDate = Date()
        nearFutureDate = currentDate.addingTimeInterval(400)
        nearPastDate = currentDate.addingTimeInterval(-400)
        longPastDate = currentDate.addingTimeInterval(-20 * 24 * 60 * 60)
    }

    @Test("Should have .intro state when loading empty state")
    func noSavedState() async throws {
        let savedState = InitializationState()
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case .intro:
            #expect(true)
        default:
            #expect(false, "\(state)")
        }
    }

    @Test(
        "Should have .intro state when loading inconsistent state",
        arguments: [
            InitializationState(endDate: nil, woundTime: nil, pausedTime: nil),
            InitializationState(endDate: nil, woundTime: 200, pausedTime: nil),
            InitializationState(endDate: nil, woundTime: nil, pausedTime: 200),
            InitializationState(endDate: Date(), woundTime: nil, pausedTime: 100),
            InitializationState(endDate: Date(), woundTime: 200, pausedTime: 100)
        ]
    )
    func inconsistentState(argument: InitializationState) async throws {
        let savedState = InitializationState()
        let state = State(
            initializationState: savedState,
            currentDate: Date()
        )

        switch state {
        case .intro:
            #expect(true)
        default:
            #expect(false, "\(state)")
        }
    }

    @Test("Should have .running when the end date is after now")
    func runningState() async throws {
        let savedState = InitializationState(
            endDate: nearFutureDate,
            woundTime: woundTime
        )
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case let .running(_, selectedTime):
            #expect(woundTime == selectedTime)
        default:
            #expect(false, "\(state)")
        }
    }

    @Test("Should have .finished when the end date is before now but not older than x days")
    func finishedState() async throws {
        let savedState = InitializationState(
            endDate: nearPastDate,
            woundTime: woundTime
        )
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case let .finished(woundTime):
            #expect(woundTime == self.woundTime)
        default:
            #expect(false, "\(state)")
        }
    }

    @Test("Should have .intro when the end date is older than x days")

    func expiredState() async throws {
        let savedState = InitializationState(
            endDate: longPastDate,
            woundTime: woundTime
        )
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        // Date handling still not implemented
        withKnownIssue {
            switch state {
            case .intro:
                #expect(true)
            default:
                #expect(false, "\(state)")
            }
        }
    }

    @Test("Should have .paused when the pausedTime is set")
    func pausedState() async throws {
        let savedState = InitializationState(
            woundTime: woundTime,
            pausedAt: pausedTime
        )
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case let .paused(remainingTime, selectedTime):
            #expect(remainingTime == pausedTime)
            #expect(woundTime == selectedTime)
        default:
            #expect(false, "\(state)")
        }
    }
}
