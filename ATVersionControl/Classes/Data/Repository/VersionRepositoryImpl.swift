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
    ) -> AnyPublisher<UpdateStatus, Error> {
        remoteSource.checkVersion(request: VersionRequestDTO(input: input))
            .tryMap { response in
                guard let status = response.updateStatus else {
                    throw ATErrorV2(errorType: .serialization)
                }
                return status
            }
            .eraseToAnyPublisher()
    }

    func getLastVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, Error> {
        remoteSource.getLastVersion(request: VersionRequestDTO(input: input))
            .map(VersionInfoMapper.map)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
