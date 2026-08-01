//
//  ColocationRepositoryImpl.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine
import Foundation

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
    ) -> AnyPublisher<[ColocationEndpoint], Error> {
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
    ) -> AnyPublisher<[ColocationEndpoint], Error> {
        guard let lane = lanes.first else {
            return Fail(error: ATErrorV2(errorType: .general) as Error)
                .eraseToAnyPublisher()
        }

        let request = ColocationRequestDTO(
            applicationName: applicationName,
            version: version,
            lane: lane
        )

        return remoteSource.getEndpoints(request: request, lane: lane)
            .tryMap { info in
                let endpoints = ColocationMapper.map(info)
                guard !endpoints.isEmpty else {
                    throw ATErrorV2(errorType: .serialization)
                }

                laneStore.save(lane)
                return endpoints
            }
            .catch { error -> AnyPublisher<[ColocationEndpoint], Error> in
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

    private func isCancellation(_ error: Error) -> Bool {
        if let networkError = error as? ATErrorV2,
           case .cancelled = networkError.errorType {
            return true
        }

        if let urlError = error as? URLError,
           urlError.code == .cancelled {
            return true
        }

        return error is CancellationError
    }
}
