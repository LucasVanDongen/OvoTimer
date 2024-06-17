import Testing

@testable import Model

typealias WindingTestArguments = (initialState: State, ticks: Ticks, expectedState: State)

typealias StartTestArguments = (initialState: State, expectedToBeRunning: Bool)

typealias DefaultModelTestArguments = (initialState: State, expectedState: State)

typealias TickTestArguments = (initialState: State, ticks: Int, expectedState: State)

@Suite("Model tests - manipulating the State")
struct ModelTests {
    @Test(
        "When the user starts winding, we always have the winding state",
        arguments: [
            WindingTestArguments(
                .intro,
                100,
                .winding(selectedTime: 100)
            ),
            WindingTestArguments(
                .intro,
                0,
                .winding(selectedTime: 0)
            ),
            WindingTestArguments(
                .intro,
                -1,
                .intro
            ),
            WindingTestArguments(
                .running(remainingTime: 50, selectedTime: 70),
                100,
                .winding(selectedTime: 100)
            ),
            WindingTestArguments(
                .paused(remainingTime: 50, selectedTime: 70),
                100,
                .winding(selectedTime: 100)
            ),
            WindingTestArguments(
                .finished(woundTime: 55),
                100,
                .winding(selectedTime: 100)
            ),
        ]
    )
    func winding(arguments: WindingTestArguments) async throws {
        let model = Model(state: arguments.initialState)
        model.wind(to: arguments.ticks)

        if case arguments.expectedState = model.state {
            #expect(true)
        } else {
            #expect(false, "Got \(model.state), expected \(arguments.expectedState)")
        }
    }

    @Test("When the user keeps winding, the wound value gets updated")
    func keepWinding() async throws {
        let expected: State = .winding(selectedTime: 100)

        let model = Model(state: .winding(selectedTime: 99))
        model.wind(to: 100)

        if case expected = model.state {
            #expect(true)
        } else {
            #expect(false, "Got \(model.state), expected \(expected)")
        }
    }

    @Test(
        "Start only works from finished or winding, puts it in the .running state",
        arguments: [
            StartTestArguments(.intro, false),
            StartTestArguments(.paused(remainingTime: 123, selectedTime: 150), false),
            StartTestArguments(.winding(selectedTime: 1), true),
            StartTestArguments(
                .running(remainingTime: 50, selectedTime: 70),
                true
            ),
            StartTestArguments(
                .finished(woundTime: 55),
                true
            )
        ]
    )
    func start(arguments: StartTestArguments) async throws {
        let model = Model(state: arguments.initialState)
        model.start()

        if case .running = model.state {
            #expect(arguments.expectedToBeRunning)
        } else {
            #expect(!arguments.expectedToBeRunning, "Got \(model.state), not expected")
        }
    }

    @Test(
        "Restart only works from finished and puts it in the .running state",
        arguments: [
            DefaultModelTestArguments(.finished(woundTime: 300), .running(remainingTime: 300, selectedTime: 300)),
            DefaultModelTestArguments(.intro, .intro),
            DefaultModelTestArguments(.winding(selectedTime: 1), .winding(selectedTime: 1)),
            DefaultModelTestArguments(.paused(remainingTime: 123, selectedTime: 300), .paused(remainingTime: 123, selectedTime: 300)
            ),
            DefaultModelTestArguments(.running(remainingTime: 300, selectedTime: 300), .running(remainingTime: 300, selectedTime: 300))
        ]
    )
    func restart(arguments: DefaultModelTestArguments) async throws {
        let model = Model(state: arguments.initialState)

        model.restart()

        if case arguments.expectedState = model.state {
            #expect(true)
        } else {
            #expect(false, "Got \(model.state), not expected")
        }
    }

    @Test(
        "Pause only works from the .running state and puts it in the .paused state",
        arguments: [
            DefaultModelTestArguments(.running(remainingTime: 123, selectedTime: 300), .paused(remainingTime: 123, selectedTime: 300)),
            DefaultModelTestArguments(.intro, .intro),
            DefaultModelTestArguments(.winding(selectedTime: 1), .winding(selectedTime: 1)),
            DefaultModelTestArguments(.paused(remainingTime: 123, selectedTime: 300), .paused(remainingTime: 123, selectedTime: 300)),
            DefaultModelTestArguments(.finished(woundTime: 300), .finished(woundTime: 300))
        ]
    )
    func pause(arguments: DefaultModelTestArguments) async throws {
        let model = Model(state: arguments.initialState)

        model.pause()

        test(expectedState: arguments.expectedState, against: model)
    }

    @Test(
        "Unpause only works from .paused",
        arguments: [
            DefaultModelTestArguments(.paused(remainingTime: 123, selectedTime: 300), .running(remainingTime: 123, selectedTime: 300)),
            DefaultModelTestArguments(.running(remainingTime: 123, selectedTime: 300), .running(remainingTime: 123, selectedTime: 300)),
            DefaultModelTestArguments(.intro, .intro),
            DefaultModelTestArguments(.winding(selectedTime: 1), .winding(selectedTime: 1)),
            DefaultModelTestArguments(.finished(woundTime: 300), .finished(woundTime: 300))
        ]
    )
    func unpause(arguments: DefaultModelTestArguments) async throws {
        let model = Model(state: arguments.initialState)

        model.unpause()

        test(expectedState: arguments.expectedState, against: model)
    }

    @Test(
        "Tick should decrement the amount of seconds left with 1",
        arguments: [
            TickTestArguments(
                .running(remainingTime: 100, selectedTime: 100),
                ticks: 1,
                expectedState: .running(remainingTime: 99, selectedTime: 100)
            ),
            TickTestArguments(
                .running(remainingTime: 100, selectedTime: 100),
                ticks: 50,
                expectedState: .running(remainingTime: 50, selectedTime: 100)
            ),
            TickTestArguments(
                .intro,
                ticks: 1,
                expectedState: .intro
            ),
            TickTestArguments(.paused(remainingTime: 123, selectedTime: 300), ticks: 1, .paused(remainingTime: 123, selectedTime: 300)),
            TickTestArguments(.intro, ticks: 1, .intro),
            TickTestArguments(.winding(selectedTime: 1), ticks: 1, .winding(selectedTime: 1)),
            TickTestArguments(.finished(woundTime: 300), ticks: 1, .finished(woundTime: 300))
        ]
    )
    func tick(arguments: TickTestArguments) async throws {
        let model = Model(state: arguments.initialState)

        for _ in 1...arguments.ticks {
            model.tick()
        }

        test(expectedState: arguments.expectedState, against: model)
    }

    @Test("When the the last second ticks away, we should get the .finished state")
    func finished() async throws {
        let model = Model(state: .running(remainingTime: 1, selectedTime: 100))
        model.tick()

        test(expectedState: .finished(woundTime: 100), against: model)
    }

    private func test(expectedState: State, against model: Model) {
        if case expectedState = model.state {
            #expect(true)
        } else {
            #expect(false, "Got \(model.state), expected \(expectedState)")
        }
    }
}
