//
//  GetLastVersionUseCase.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct GetLastVersionUseCase {
    private let repository: any VersionRepository

    init(repository: any VersionRepository) {
        self.repository = repository
    }

    func execute(
        _ input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, ATErrorV2> {
        repository.getLastVersion(for: input)
    }
}
