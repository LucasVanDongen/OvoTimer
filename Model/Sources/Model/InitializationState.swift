//
//  InitializationState.swift
//
//
//  Created by Lucas van Dongen on 13/06/2024.
//

import Foundation

/// State loaded from disk at app boot, and saved to disk at regular intervals
struct InitializationState {
    let storeDate: Date?
    let endDate: Date?
    let woundTime: Ticks?
    let pausedTime: Ticks?

    /// Use this when there is nothing to save
    init() {
        storeDate = Date()
        endDate = nil
        woundTime = nil
        pausedTime = nil
    }

    /// Use this to save a running timer, or one that has finished already
    init(
        storeDate: Date,
        endDate: Date,
        woundTime: Ticks
    ) {
        self.storeDate = storeDate
        self.endDate = endDate
        self.woundTime = woundTime
        pausedTime = nil
    }

    /// Use this to save a paused timer
    init(
        storeDate: Date,
        woundTime: Ticks,
        pausedAt pausedTime: Ticks
    ) {
        self.storeDate = storeDate
        endDate = nil
        self.woundTime = woundTime
        self.pausedTime = pausedTime
    }

    /// Only for testing purposes
    init(
        storeDate: Date,
        endDate: Date?,
        woundTime: Ticks?,
        pausedTime: Ticks?
    ) {
        self.storeDate = storeDate
        self.endDate = endDate
        self.woundTime = woundTime
        self.pausedTime = pausedTime
    }
}
