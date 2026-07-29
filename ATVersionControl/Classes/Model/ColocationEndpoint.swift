//
//  ColocationEndpoint.swift
//  ATVersionControl
//
//  Created by Amir on 7/13/26.
//
public struct ColocationEndpoint: Decodable, Sendable {
    public var name = ""
    public var baseURL = ""

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case baseURL = "BaseUrl"
    }

    static func from(json object: [String: Any]?) -> ColocationEndpoint? {
        guard let object = object else {
            return nil
        }

        var result = ColocationEndpoint()
        result.name = object["Name"] as? String ?? ""
        result.baseURL = object["BaseUrl"] as? String ?? ""

        guard !result.name.isEmpty, !result.baseURL.isEmpty else {
            return nil
        }

        return result
    }
}
