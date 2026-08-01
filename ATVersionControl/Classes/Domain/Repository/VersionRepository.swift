//
//  VersionRepository.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

protocol VersionRepository {
    func checkVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<UpdateStatus, ATErrorV2>

    func getLastVersion(
        for input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, ATErrorV2>
}
