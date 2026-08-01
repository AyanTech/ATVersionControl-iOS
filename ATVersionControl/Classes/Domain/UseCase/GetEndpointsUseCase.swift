//
//  GetEndpointsUseCase.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct GetEndpointsUseCase {
    private let repository: any ColocationRepository
    private let laneStore: any ColocationLaneStoring

    init(
        repository: any ColocationRepository,
        laneStore: any ColocationLaneStoring
    ) {
        self.repository = repository
        self.laneStore = laneStore
    }

    func execute(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        guard !applicationName.isEmpty, !version.isEmpty else {
            return Fail(error: ATErrorV2(errorType: .invalidRequest))
                .eraseToAnyPublisher()
        }

        return tryNextLane(
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

        return repository.getEndpoints(
            applicationName: applicationName,
            version: version,
            lane: lane
        )
        .flatMap { endpoints -> AnyPublisher<[ColocationEndpoint], ATErrorV2> in
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

}
