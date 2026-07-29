//
//  ColocationClient.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine
import Foundation

struct ColocationClient: Sendable {
    struct URLs: Sendable {
        let iran: String
        let international: String
    }

    private struct Request: Encodable, Sendable {
        let applicationName: String
        let applicationType = "ios"
        let colocationType: String
        let currentApplicationVersion: String

        enum CodingKeys: String, CodingKey {
            case applicationName = "ApplicationName"
            case applicationType = "ApplicationType"
            case colocationType = "ColocationType"
            case currentApplicationVersion = "CurrentApplicationVersion"
        }
    }

    private enum Lane: Sendable {
        case iran
        case international

        var type: String {
            switch self {
            case .iran:
                return "Iran1"
            case .international:
                return "International"
            }
        }
    }

    private static let cacheKey = "ATVersionControl.cache.colocationType"

    private let urls: URLs
    private let configuration: ConfigurationV2

    init(urls: URLs, configuration: ConfigurationV2 = .init()) {
        self.urls = urls
        self.configuration = configuration
    }

    func getEndpoints(
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        getEndpoints(
            lanes: lanesInTryOrder(),
            applicationName: applicationName,
            version: version
        )
    }

    private func getEndpoints(
        lanes: [Lane],
        applicationName: String,
        version: String
    ) -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        guard let lane = lanes.first else {
            return Fail(error: ATErrorV2(errorType: .general))
                .eraseToAnyPublisher()
        }

        let request = Request(
            applicationName: applicationName,
            colocationType: lane.type,
            currentApplicationVersion: version
        )

        return ATRequestV2(
            url: url(for: lane),
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(ColocationInfo.self)
        .tryMap { info in
            let endpoints = info.endpoints
            guard !endpoints.isEmpty else {
                throw ATErrorV2(errorType: .serialization)
            }

            UserDefaults.standard.set(lane.type, forKey: Self.cacheKey)
            return endpoints
        }
        .mapError(ATErrorV2.from)
        .catch { error in
            guard case .cancelled = error.errorType else {
                return getEndpoints(
                    lanes: Array(lanes.dropFirst()),
                    applicationName: applicationName,
                    version: version
                )
            }

            return Fail<[ColocationEndpoint], ATErrorV2>(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    private func lanesInTryOrder() -> [Lane] {
        switch UserDefaults.standard.string(forKey: Self.cacheKey) {
        case Lane.international.type:
            return [.international, .iran]
        default:
            return [.iran, .international]
        }
    }

    private func url(for lane: Lane) -> String {
        switch lane {
        case .iran:
            return urls.iran
        case .international:
            return urls.international
        }
    }
}
