//
//  GetEndpointsUseCase.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct GetEndpointsUseCase {
    private let repository: any ColocationRepository

    init(repository: any ColocationRepository) {
        self.repository = repository
    }

    func execute(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        repository.getEndpoints(
            applicationName: applicationName,
            version: version
        )
    }
}
