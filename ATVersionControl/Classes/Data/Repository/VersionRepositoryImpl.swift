//
//  VersionRepositoryImpl.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct VersionRepositoryImpl: VersionRepository {
    private let remoteSource: any VersionRemoteSourceProtocol

    init(remoteSource: any VersionRemoteSourceProtocol) {
        self.remoteSource = remoteSource
    }

    func checkVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<UpdateStatus, ATErrorV2> {
        remoteSource.checkVersion(request: VersionRequestDTO(input: input))
            .flatMap { response -> AnyPublisher<UpdateStatus, ATErrorV2> in
                guard let status = response.updateStatus else {
                    return Fail(error: ATErrorV2(errorType: .serialization))
                        .eraseToAnyPublisher()
                }

                return Just(status)
                    .setFailureType(to: ATErrorV2.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func getLastVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, ATErrorV2> {
        remoteSource.getLastVersion(request: VersionRequestDTO(input: input))
            .map(VersionInfoMapper.map)
            .eraseToAnyPublisher()
    }
}
