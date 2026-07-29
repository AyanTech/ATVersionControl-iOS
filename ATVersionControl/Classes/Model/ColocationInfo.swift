//
//  ColocationInfo.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary

struct ColocationInfo: Decodable, Sendable {
    static let versionControlEndpointName = "VersionControl"

    var endpoints = [ColocationEndpoint]()

    enum CodingKeys: String, CodingKey {
        case endpoints = "EndpointList"
    }

    static func from(response: ATResponse) -> ColocationInfo? {
        guard response.isSuccess, let parameters = response.parametersJsonObject else {
            return nil
        }

        var result = ColocationInfo()

        if let objects = parameters["EndpointList"] as? [[String: Any]] {
            result.endpoints = objects.compactMap { ColocationEndpoint.from(json: $0) }
        }

        return result.endpoints.isEmpty ? nil : result
    }
}
