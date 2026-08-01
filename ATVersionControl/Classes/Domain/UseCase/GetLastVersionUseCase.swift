//
//  GetLastVersionUseCase.swift
//  ATVersionControl
//

import Combine

struct GetLastVersionUseCase {
    private let repository: any VersionRepository

    init(repository: any VersionRepository) {
        self.repository = repository
    }

    func execute(
        _ input: VersionCheckInput
    ) -> AnyPublisher<VersionInfo, Error> {
        repository.getLastVersion(for: input)
    }
}
