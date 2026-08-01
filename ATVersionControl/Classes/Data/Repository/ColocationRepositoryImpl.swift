//
//  ColocationRepositoryImpl.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct ColocationRepositoryImpl: ColocationRepository {
    private let remoteSource: any ColocationRemoteSourceProtocol

    init(remoteSource: any ColocationRemoteSourceProtocol) {
        self.remoteSource = remoteSource
    }

    func getEndpoints(
        applicationName: String,
        version: String,
        lane: ColocationLane
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        let request = ColocationRequestDTO(
            applicationName: applicationName,
            version: version,
            lane: lane
        )

        return remoteSource.getEndpoints(request: request, lane: lane)
            .map(ColocationMapper.map)
            .eraseToAnyPublisher()
    }
}
