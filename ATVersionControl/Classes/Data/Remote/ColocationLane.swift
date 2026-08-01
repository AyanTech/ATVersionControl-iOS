//
//  ColocationLane.swift
//  ATVersionControl
//

enum ColocationLane: String, CaseIterable, Sendable {
    case iran = "Iran1"
    case international = "International"

    var colocationType: String {
        rawValue
    }
}
