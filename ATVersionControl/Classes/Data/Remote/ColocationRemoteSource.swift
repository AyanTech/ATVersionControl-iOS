//
//  ColocationRemoteSource.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

protocol ColocationRemoteSourceProtocol {
    func getEndpoints(
        request: ColocationRequestDTO,
        lane: ColocationLane
    ) -> AnyPublisher<ColocationInfoDTO, ATErrorV2>
}

struct ColocationRemoteSource: ColocationRemoteSourceProtocol, Sendable {
    private let iranURL: String
    private let internationalURL: String
    private let configuration: ConfigurationV2

    init(
        iranURL: String,
        internationalURL: String,
        configuration: ConfigurationV2
    ) {
        self.iranURL = iranURL
        self.internationalURL = internationalURL
        self.configuration = configuration
    }

    func getEndpoints(
        request: ColocationRequestDTO,
        lane: ColocationLane
    ) -> AnyPublisher<ColocationInfoDTO, ATErrorV2> {
        ATRequestV2(
            url: url(for: lane),
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(ColocationInfoDTO.self)
    }

    private func url(for lane: ColocationLane) -> String {
        switch lane {
        case .iran:
            return iranURL
        case .international:
            return internationalURL
        }
    }
}
