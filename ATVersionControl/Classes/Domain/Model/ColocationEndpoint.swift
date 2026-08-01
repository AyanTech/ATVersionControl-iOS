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
}
