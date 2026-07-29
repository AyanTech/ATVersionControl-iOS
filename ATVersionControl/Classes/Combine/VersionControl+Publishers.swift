//
//  VersionControl+Publishers.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine
import UIKit

public extension VersionControl {
    func checkVersionPublisher() -> AnyPublisher<UpdateStatus, ATErrorV2> {
        buildVersionClient().checkVersion(
            applicationName: applicationName,
            version: version,
            categoryName: categoryName,
            extraInfo: extraInfo
        )
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
        buildVersionClient().getLastVersion(
            applicationName: applicationName,
            version: version,
            categoryName: categoryName,
            extraInfo: extraInfo
        )
    }

    func getEndpointsPublisher() -> AnyPublisher<[ColocationEndpoint], ATErrorV2> {
        buildColocationClient()
            .getEndpoints(applicationName: applicationName, version: version)
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveOutput: { endpoints in
                    MainActor.assumeIsolated {
                        ATUrl.versionControlBaseURL = endpoints
                            .first(where: { $0.name == "VersionControl" })?
                            .baseURL ?? ATUrl.defaultVersionControlBaseURL
                    }
                },
                receiveCompletion: { completion in
                    guard case .failure = completion else { return }
                    MainActor.assumeIsolated {
                        ATUrl.versionControlBaseURL = ATUrl.defaultVersionControlBaseURL
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
                    let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                    guard let viewController = Utils.getTopMostViewController() else { return }
                    activity.popoverPresentationController?.sourceView = viewController.view
                    activity.popoverPresentationController?.sourceRect = CGRect(
                        x: viewController.view.bounds.midX,
                        y: viewController.view.bounds.midY,
                        width: 0,
                        height: 0
                    )
                    activity.popoverPresentationController?.permittedArrowDirections = []
                    viewController.present(activity, animated: true)
                }
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    private func buildVersionClient() -> VersionClient {
        VersionClient(
            urls: VersionClient.URLs(
                checkVersion: ATUrl.checkVersion,
                getLastVersion: ATUrl.getLastVersion
            )
        )
    }

    private func buildColocationClient() -> ColocationClient {
        ColocationClient(
            urls: ColocationClient.URLs(
                iran: ATUrl.iranGetApplicationColocationConfig,
                international: ATUrl.internationalGetApplicationColocationConfig
            )
        )
    }
}
