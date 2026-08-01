//
//  ColocationRepository.swift
//  ATVersionControl
//

import Combine

protocol ColocationRepository {
    func getEndpoints(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], Error>
}
