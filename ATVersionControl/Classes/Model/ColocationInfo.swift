//
//  ColocationInfo.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary

class ColocationInfo {
    static let versionControlEndpointName = "VersionControl"

    var endpoints = [ColocationEndpoint]()

    class func from(response: ATResponse) -> ColocationInfo? {
        guard response.isSuccess, let parameters = response.parametersJsonObject else {
            return nil
        }

        let result = ColocationInfo()

        if let objects = parameters["EndpointList"] as? [[String: Any]] {
            result.endpoints = objects.compactMap { ColocationEndpoint.from(json: $0) }
        }

        return result.endpoints.isEmpty ? nil : result
    }
}
