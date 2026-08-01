//
//  ColocationInfoDTO.swift
//  ATVersionControl
//

struct ColocationInfoDTO: Decodable, Sendable {
    let endpoints: [ColocationEndpointDTO]

    enum CodingKeys: String, CodingKey {
        case endpoints = "EndpointList"
    }
}

struct ColocationEndpointDTO: Decodable, Sendable {
    let name: String
    let baseURL: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case baseURL = "BaseUrl"
    }
}
