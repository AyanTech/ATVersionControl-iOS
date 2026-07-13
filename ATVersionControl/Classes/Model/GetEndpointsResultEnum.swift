//
//  GetEndpointsResultEnum.swift
//  ATVersionControl
//
//  Created by Amir on 7/13/26.
//

public enum GetEndpointsResult {
    case success(endpoints: [ColocationEndpoint])
    case failure
}
