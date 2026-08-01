//
//  ColocationRepositoryImpl.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct ColocationRepositoryImpl: ColocationRepository {
    private let remoteSource: any ColocationRemoteSourceProtocol
    private let laneStore: any ColocationLaneStoring

    init(
        remoteSource: any ColocationRemoteSourceProtocol,
        laneStore: any ColocationLaneStoring = ColocationLaneStore()
    ) {
        self.remoteSource = remoteSource
        self.laneStore = laneStore
    }

    func getEndpoints(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        tryNextLane(
            lanes: lanesInTryOrder(),
            applicationName: applicationName,
            version: version
        )
    }

    private func tryNextLane(
        lanes: [ColocationLane],
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        guard let lane = lanes.first else {
            return Fail(error: ATErrorV2(errorType: .general))
                .eraseToAnyPublisher()
        }

        let request = ColocationRequestDTO(
            applicationName: applicationName,
            version: version,
            lane: lane
        )

        return remoteSource.getEndpoints(request: request, lane: lane)
            .flatMap { info -> AnyPublisher<[ColocationEndpoint], ATErrorV2> in
                let endpoints = ColocationMapper.map(info)
                guard !endpoints.isEmpty else {
                    return Fail(error: ATErrorV2(errorType: .serialization))
                        .eraseToAnyPublisher()
                }

                laneStore.save(lane)
                return Just(endpoints)
                    .setFailureType(to: ATErrorV2.self)
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<[ColocationEndpoint], ATErrorV2> in
                guard !isCancellation(error) else {
                    return Fail(error: error).eraseToAnyPublisher()
                }

                return tryNextLane(
                    lanes: Array(lanes.dropFirst()),
                    applicationName: applicationName,
                    version: version
                )
            }
            .eraseToAnyPublisher()
    }

    private func lanesInTryOrder() -> [ColocationLane] {
        switch laneStore.load() {
        case .international:
            return [.international, .iran]
        default:
            return [.iran, .international]
        }
    }

    private func isCancellation(_ error: ATErrorV2) -> Bool {
        if case .cancelled = error.errorType {
            return true
        }
        return false
    }
}
