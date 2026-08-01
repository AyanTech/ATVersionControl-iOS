//
//  ColocationRepository.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

protocol ColocationRepository {
    func getEndpoints(
        applicationName: String,
        version: String,
        lane: ColocationLane
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2>
}
