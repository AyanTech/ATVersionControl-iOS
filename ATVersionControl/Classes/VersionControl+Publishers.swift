//
//  VersionControl+Publishers.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine
import Foundation

public extension VersionControl {
    func checkVersionPublisher() -> AnyPublisher<UpdateStatus, ATErrorV2> {
        let useCase = CheckVersionUseCase(repository: buildVersionRepository())

        return useCase.execute(buildVersionCheckInput())
            .mapError(ATErrorV2.from)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] result in
                guard let versionInfo = result.versionInfo else {
                    return
                }

                MainActor.assumeIsolated {
                    self?.showUpdateDialog(
                        updateStatus: result.status,
                        versionInfo: versionInfo
                    )
                }
            })
            .map(\.status)
            .eraseToAnyPublisher()
    }

    func getLastVersionPublisher() -> AnyPublisher<VersionInfo, ATErrorV2> {
        let useCase = GetLastVersionUseCase(repository: buildVersionRepository())

        return useCase.execute(buildVersionCheckInput())
            .mapError(ATErrorV2.from)
            .eraseToAnyPublisher()
    }

    func getEndpointsPublisher() -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        let useCase = GetEndpointsUseCase(
            repository: buildColocationRepository()
        )

        return useCase.execute(
            applicationName: applicationName,
            version: version
        )
        .mapError(ATErrorV2.from)
        .receive(on: DispatchQueue.main)
        .handleEvents(
            receiveOutput: { endpoints in
                MainActor.assumeIsolated {
                    VersionControlAPI.apply(endpoints: endpoints)
                }
            },
            receiveCompletion: { completion in
                guard case .failure = completion else {
                    return
                }

                MainActor.assumeIsolated {
                    VersionControlAPI.reset()
                }
            }
        )
        .eraseToAnyPublisher()
    }

    func shareAppLinkPublisher() -> AnyPublisher<Void, ATErrorV2> {
        getLastVersionPublisher()
            .map(\.textToShare)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { textToShare in
                MainActor.assumeIsolated {
                    ShareSheetPresenter.present(text: textToShare)
                }
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    private func buildVersionCheckInput() -> VersionCheckInput {
        VersionCheckInput(
            applicationName: applicationName,
            version: version,
            categoryName: categoryName,
            extraInfo: extraInfo
        )
    }

    private func buildVersionRepository() -> VersionRepositoryImpl {
        VersionRepositoryImpl(
            remoteSource: VersionRemoteSource(
                checkVersionURL: VersionControlAPI.checkVersionURL,
                getLastVersionURL: VersionControlAPI.getLastVersionURL,
                configuration: networkingConfiguration
            )
        )
    }

    private func buildColocationRepository() -> ColocationRepositoryImpl {
        ColocationRepositoryImpl(
            remoteSource: ColocationRemoteSource(
                iranURL: VersionControlAPI.iranColocationURL,
                internationalURL: VersionControlAPI.internationalColocationURL,
                configuration: networkingConfiguration
            )
        )
    }
}
