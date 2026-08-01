//
//  ColocationLaneStore.swift
//  ATVersionControl
//

import Foundation

protocol ColocationLaneStoring {
    func load() -> ColocationLane?
    func save(_ lane: ColocationLane)
}

struct ColocationLaneStore: ColocationLaneStoring {
    private static let cacheKey = "ATVersionControl.cache.colocationType"

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> ColocationLane? {
        userDefaults.string(forKey: Self.cacheKey)
            .flatMap(ColocationLane.init(rawValue:))
    }

    func save(_ lane: ColocationLane) {
        userDefaults.set(lane.rawValue, forKey: Self.cacheKey)
    }
}
