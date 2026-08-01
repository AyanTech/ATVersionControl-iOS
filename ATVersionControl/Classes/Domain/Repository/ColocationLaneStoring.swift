//
//  ColocationLaneStoring.swift
//  ATVersionControl
//

protocol ColocationLaneStoring {
    func load() -> ColocationLane?
    func save(_ lane: ColocationLane)
}
