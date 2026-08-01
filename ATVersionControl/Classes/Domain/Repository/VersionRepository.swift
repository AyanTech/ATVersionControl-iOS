//
//  VersionRepository.swift
//  ATVersionControl
//

import Combine

protocol VersionRepository {
    func checkVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<UpdateStatus, Error>

    func getLastVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, Error>
}
