//
//  CheckVersionUseCase.swift
//  ATVersionControl
//

import Combine

struct CheckVersionUseCase {
    private let repository: any VersionRepository

    init(repository: any VersionRepository) {
        self.repository = repository
    }

    func execute(
        _ input: VersionCheckInput
    ) -> AnyPublisher<VersionCheckResult, Error> {
        repository.checkVersion(for: input)
            .flatMap { status -> AnyPublisher<VersionCheckResult, Error> in
                guard status != .notRequired else {
                    return Just(
                        VersionCheckResult(
                            status: status,
                            versionInfo: nil
                        )
                    )
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                }

                return repository.getLastVersion(for: input)
                    .map { versionInfo in
                        VersionCheckResult(
                            status: status,
                            versionInfo: versionInfo
                        )
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
