//
//  ColocationMapper.swift
//  ATVersionControl
//

enum ColocationMapper {
    static func map(_ dto: ColocationInfoDTO) -> [ColocationEndpoint] {
        dto.endpoints.map(map)
    }

    private static func map(_ dto: ColocationEndpointDTO) -> ColocationEndpoint {
        var endpoint = ColocationEndpoint()
        endpoint.name = dto.name
        endpoint.baseURL = dto.baseURL
        return endpoint
    }
}
