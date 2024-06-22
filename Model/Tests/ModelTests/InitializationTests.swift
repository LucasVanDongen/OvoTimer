//
//  InitializationTests.swift
//
//
//  Created by Lucas van Dongen on 13/06/2024.
//

import Foundation
import Testing

@testable import Model

// 10 minutes ago
private let storeDateFresh = Date().addingTimeInterval(-600)
// a day ago
private let storeDateStale = Date().addingTimeInterval(-60 * 60 * 24)
// 400 seconds into the future
private let nearFutureDate = Date().addingTimeInterval(400)

private let woundTime: Ticks = 500
private let pausedTime: Ticks = 123
private let currentDate = Date()
private let nearPastDate = Date().addingTimeInterval(-400)

@Suite
struct InitializationTests {
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
            #expect(Bool(false), "\(state)")
        }
    }

    @Test(
        "Should have .intro state when loading any kind of state stored over 8 hours ago",
        .tags(.introducing),
        arguments: [       
            InitializationState(
                storeDate: storeDateStale,
                endDate: nearFutureDate,
                woundTime: woundTime
            ),
            InitializationState(
                storeDate: storeDateStale,
                endDate: nearFutureDate,
                woundTime: woundTime
            ),
            InitializationState(
                storeDate: storeDateStale,
                endDate: nearPastDate,
                woundTime: woundTime
            ),
            InitializationState(
                storeDate: storeDateStale,
                woundTime: woundTime,
                pausedAt: pausedTime
            )
        ]
    )
    func expiredSavedState(savedState: InitializationState) async throws {
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case .intro:
            #expect(true)
        default:
            #expect(Bool(false), "\(state)")
        }
    }

    @Test("Should have .running when the end date is after now", .tags(.running))
    func runningState() async throws {
        let savedState = InitializationState(
            storeDate: storeDateFresh,
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
            #expect(Bool(false), "\(state)")
        }
    }

    @Test("Should have .finished when the end date is before now but not older than x days", .tags(.finishing))
    func finishedState() async throws {
        let savedState = InitializationState(
            storeDate: storeDateFresh,
            endDate: nearPastDate,
            woundTime: woundTime
        )
        let state = State(
            initializationState: savedState,
            currentDate: currentDate
        )

        switch state {
        case let .finished(woundTime):
            #expect(woundTime == woundTime)
        default:
            #expect(Bool(false), "\(state)")
        }
    }

    @Test("Should have .paused when the pausedTime is set", .tags(.pausing))
    func pausedState() async throws {
        let savedState = InitializationState(
            storeDate: storeDateFresh,
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
            #expect(Bool(false), "\(state)")
        }
    }

    @Test(
        "Should have .intro state when loading inconsistent state",
        .tags(.introducing),
        arguments: [
            InitializationState(storeDate: storeDateFresh, endDate: nil, woundTime: nil, pausedTime: nil),
            InitializationState(storeDate: storeDateFresh, endDate: nil, woundTime: 200, pausedTime: nil),
            InitializationState(storeDate: storeDateFresh, endDate: nil, woundTime: nil, pausedTime: 200),
            InitializationState(storeDate: storeDateFresh, endDate: Date(), woundTime: nil, pausedTime: 100),
            InitializationState(storeDate: storeDateFresh, endDate: Date(), woundTime: 200, pausedTime: 100)
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
            #expect(Bool(false), "\(state)")
        }
    }

    @Test(
        "Store date is stale after 8 days",
        arguments: [
            (storeDateStale, true),
            (storeDateFresh, false)
        ]
    )
    func isStoredState(with storeDate: Date, expectedToBeStale: Bool) {
        #expect(
            State.is(storeDate: storeDate, staleComparedTo: currentDate) == expectedToBeStale
        )
    }
}
