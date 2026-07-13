//
//  Colocation.swift
//  ATVersionControl
//

import Foundation
import AyanTechNetworkingLibrary

/// Resolves colocation by POSTing GetApplicationColocationConfig per lane.
/// - Tries Iran then International, or the reverse if UserDefaults holds the last successful
///   ColocationType (`Iran1` / `International`).
/// - Cache only affects try order on the next call; each resolve still performs network requests.
/// - On success: sets ATUrl.versionControlBaseURL from the VersionControl endpoint (or default), caches lane type.
/// - On failure (both lanes): resets versionControlBaseURL to default and completes with `.failure`.
enum ColocationResolver {
    private static let cacheKey = "ATVersionControl.cache.colocationType"

    static func resolve(applicationName: String, version: String, completion: @escaping (GetEndpointsResult) -> Void) {
        tryLanes(lanesInTryOrder(), applicationName: applicationName, version: version, completion: completion)
    }

    private static func lanesInTryOrder() -> [ColocationLane] {
        switch UserDefaults.standard.string(forKey: cacheKey) {
        case ColocationLane.international.colocationType:
            return [.international, .iran]
        default:
            return [.iran, .international]
        }
    }

    private static func tryLanes(
        _ lanes: [ColocationLane],
        applicationName: String,
        version: String,
        completion: @escaping (GetEndpointsResult) -> Void
    ) {
        guard let lane = lanes.first else {
            ATUrl.versionControlBaseURL = ATUrl.defaultVersionControlBaseURL
            finish(.failure, completion: completion)
            return
        }

        fetchEndpoints(lane: lane, applicationName: applicationName, version: version) { info in
            if let info = info {
                if let versionControl = info.endpoints.first(where: { $0.name == ColocationInfo.versionControlEndpointName }) {
                    ATUrl.versionControlBaseURL = versionControl.baseURL
                } else {
                    ATUrl.versionControlBaseURL = ATUrl.defaultVersionControlBaseURL
                }
                UserDefaults.standard.set(lane.colocationType, forKey: cacheKey)
                finish(.success(endpoints: info.endpoints), completion: completion)
            } else {
                tryLanes(Array(lanes.dropFirst()), applicationName: applicationName, version: version, completion: completion)
            }
        }
    }

    private static func fetchEndpoints(
        lane: ColocationLane,
        applicationName: String,
        version: String,
        completion: @escaping (ColocationInfo?) -> Void
    ) {
        let url: String
        switch lane {
        case .iran:
            url = ATUrl.iranGetApplicationColocationConfig
        case .international:
            url = ATUrl.internationalGetApplicationColocationConfig
        }

        ATRequest.request(url: url, method: .post)
            .setJsonBody(body: [
                "Parameters": [
                    "ApplicationName": applicationName,
                    "ApplicationType": "ios",
                    "ColocationType": lane.colocationType,
                    "CurrentApplicationVersion": version
                ]
            ], ignoreParameterCreator: true)
            .send { response in
                completion(ColocationInfo.from(response: response))
            }
    }

    private static func finish(_ result: GetEndpointsResult, completion: @escaping (GetEndpointsResult) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

private enum ColocationLane {
    case iran
    case international

    var colocationType: String {
        switch self {
        case .iran:
            return "Iran1"
        case .international:
            return "International"
        }
    }
}
