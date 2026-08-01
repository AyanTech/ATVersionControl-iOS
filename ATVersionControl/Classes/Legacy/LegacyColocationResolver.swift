//
//  LegacyColocationResolver.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Foundation

@MainActor
enum LegacyColocationResolver {
    private static let cacheKey = "ATVersionControl.cache.colocationType"

    static func resolve(
        applicationName: String,
        version: String,
        completion: @MainActor @escaping (GetEndpointsResult) -> Void
    ) {
        tryLanes(
            lanesInTryOrder(),
            applicationName: applicationName,
            version: version,
            completion: completion
        )
    }

    private static func tryLanes(
        _ lanes: [LegacyColocationLane],
        applicationName: String,
        version: String,
        completion: @MainActor @escaping (GetEndpointsResult) -> Void
    ) {
        guard let lane = lanes.first else {
            VersionControlAPI.reset()
            finish(.failure, completion: completion)
            return
        }

        fetchEndpoints(
            lane: lane,
            applicationName: applicationName,
            version: version
        ) { info in
            guard let info else {
                tryLanes(
                    Array(lanes.dropFirst()),
                    applicationName: applicationName,
                    version: version,
                    completion: completion
                )
                return
            }

            VersionControlAPI.apply(endpoints: info.endpoints)
            UserDefaults.standard.set(lane.colocationType, forKey: cacheKey)
            finish(.success(endpoints: info.endpoints), completion: completion)
        }
    }

    private static func fetchEndpoints(
        lane: LegacyColocationLane,
        applicationName: String,
        version: String,
        completion: @MainActor @escaping (LegacyColocationInfo?) -> Void
    ) {
        let url = switch lane {
        case .iran:
            VersionControlAPI.iranColocationURL
        case .international:
            VersionControlAPI.internationalColocationURL
        }

        ATRequest.request(url: url, method: .post)
            .setJsonBody(
                body: [
                    "Parameters": [
                        "ApplicationName": applicationName,
                        "ApplicationType": "ios",
                        "ColocationType": lane.colocationType,
                        "CurrentApplicationVersion": version
                    ]
                ],
                ignoreParameterCreator: true
            )
            .send { response in
                MainActor.assumeIsolated {
                    completion(LegacyColocationInfo.from(response: response))
                }
            }
    }

    private static func lanesInTryOrder() -> [LegacyColocationLane] {
        switch UserDefaults.standard.string(forKey: cacheKey) {
        case LegacyColocationLane.international.colocationType:
            return [.international, .iran]
        default:
            return [.iran, .international]
        }
    }

    private static func finish(
        _ result: GetEndpointsResult,
        completion: @MainActor @escaping (GetEndpointsResult) -> Void
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

private struct LegacyColocationInfo {
    let endpoints: [ColocationEndpoint]

    static func from(response: ATResponse) -> LegacyColocationInfo? {
        guard
            response.isSuccess,
            let objects = response.parametersJsonObject?["EndpointList"] as? [[String: Any]]
        else {
            return nil
        }

        let endpoints = objects.compactMap { object -> ColocationEndpoint? in
            guard
                let name = object["Name"] as? String,
                !name.isEmpty,
                let baseURL = object["BaseUrl"] as? String,
                !baseURL.isEmpty
            else {
                return nil
            }

            var endpoint = ColocationEndpoint()
            endpoint.name = name
            endpoint.baseURL = baseURL
            return endpoint
        }

        guard !endpoints.isEmpty else {
            return nil
        }

        return LegacyColocationInfo(endpoints: endpoints)
    }
}

private enum LegacyColocationLane {
    case iran
    case international

    var colocationType: String {
        switch self {
        case .iran:
            "Iran1"
        case .international:
            "International"
        }
    }
}
