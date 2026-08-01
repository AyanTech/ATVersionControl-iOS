//
//  GetEndpointsUseCase.swift
//  ATVersionControl
//

import Combine

struct GetEndpointsUseCase {
    private let repository: any ColocationRepository

    init(repository: any ColocationRepository) {
        self.repository = repository
    }

    func execute(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], Error> {
        repository.getEndpoints(
            applicationName: applicationName,
            version: version
        )
    }
}
