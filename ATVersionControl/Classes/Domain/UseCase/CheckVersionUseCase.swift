//
//  CheckVersionUseCase.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct CheckVersionUseCase {
    private let repository: any VersionRepository

    init(repository: any VersionRepository) {
        self.repository = repository
    }

    func execute(
        _ input: VersionCheckInput
    ) -> AnyPublisher<VersionCheckResult, ATErrorV2> {
        repository.checkVersion(for: input)
            .flatMap { status -> AnyPublisher<VersionCheckResult, ATErrorV2> in
                guard status != .notRequired else {
                    return Just(
                        VersionCheckResult(
                            status: status,
                            versionInfo: nil
                        )
                    )
                    .setFailureType(to: ATErrorV2.self)
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
