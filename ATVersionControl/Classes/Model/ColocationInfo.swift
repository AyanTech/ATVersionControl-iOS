//
//  ColocationInfo.swift
//  ATVersionControl
//

import Foundation
import AyanTechNetworkingLibrary
import SwiftBooster

public enum GetEndpointsResult {
    case success(endpoints: [ColocationEndpoint])
    case failure
}

public class ColocationEndpoint {
    public var name = ""
    public var baseURL = ""

    class func from(json object: JSONObject?) -> ColocationEndpoint? {
        guard let object = object else {
            return nil
        }

        let result = ColocationEndpoint()
        result.name = getValue(input: object, subscripts: "Name") ?? ""
        result.baseURL = getValue(input: object, subscripts: "BaseUrl") ?? ""

        guard !result.name.isEmpty, !result.baseURL.isEmpty else {
            return nil
        }

        return result
    }
}

class ColocationInfo {
    static let versionControlEndpointName = "VersionControl"

    var endpoints = [ColocationEndpoint]()

    class func from(response: ATResponse) -> ColocationInfo? {
        guard response.isSuccess, let parameters = response.parametersJsonObject else {
            return nil
        }

        let result = ColocationInfo()

        if let objects: [JSONObject] = getValue(input: parameters, subscripts: "EndpointList") {
            result.endpoints = objects.compactMap { ColocationEndpoint.from(json: $0) }
        }

        return result.endpoints.isEmpty ? nil : result
    }
}
