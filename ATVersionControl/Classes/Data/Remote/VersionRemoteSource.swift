//
//  VersionRemoteSource.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

protocol VersionRemoteSourceProtocol {
    func checkVersion(
        request: VersionRequestDTO
    ) -> AnyPublisher<CheckVersionResponseDTO, ATErrorV2>

    func getLastVersion(
        request: VersionRequestDTO
    ) -> AnyPublisher<VersionInfoDTO, ATErrorV2>
}

struct VersionRemoteSource: VersionRemoteSourceProtocol, Sendable {
    private let checkVersionURL: String
    private let getLastVersionURL: String
    private let configuration: ConfigurationV2

    init(
        checkVersionURL: String,
        getLastVersionURL: String,
        configuration: ConfigurationV2
    ) {
        self.checkVersionURL = checkVersionURL
        self.getLastVersionURL = getLastVersionURL
        self.configuration = configuration
    }

    func checkVersion(
        request: VersionRequestDTO
    ) -> AnyPublisher<CheckVersionResponseDTO, ATErrorV2> {
        ATRequestV2(
            url: checkVersionURL,
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(CheckVersionResponseDTO.self)
    }

    func getLastVersion(
        request: VersionRequestDTO
    ) -> AnyPublisher<VersionInfoDTO, ATErrorV2> {
        ATRequestV2(
            url: getLastVersionURL,
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(VersionInfoDTO.self)
    }
}
