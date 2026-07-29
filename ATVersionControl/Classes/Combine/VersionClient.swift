//
//  VersionClient.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Combine

struct VersionClient: Sendable {
    struct URLs: Sendable {
        let checkVersion: String
        let getLastVersion: String
    }

    private struct VersionRequest: Encodable, Sendable {
        let applicationName: String
        let applicationType = "ios"
        let categoryName: String
        let currentApplicationVersion: String
        let extraInfo: [String: String]

        enum CodingKeys: String, CodingKey {
            case applicationName = "ApplicationName"
            case applicationType = "ApplicationType"
            case categoryName = "CategoryName"
            case currentApplicationVersion = "CurrentApplicationVersion"
            case extraInfo = "ExtraInfo"
        }
    }

    private struct CheckVersionResponse: Decodable, Sendable {
        let updateStatus: UpdateStatus?

        enum CodingKeys: String, CodingKey {
            case updateStatus = "UpdateStatus"
        }
    }

    private let urls: URLs
    private let configuration: ConfigurationV2

    init(urls: URLs, configuration: ConfigurationV2 = .init()) {
        self.urls = urls
        self.configuration = configuration
    }

    func checkVersion(
        applicationName: String,
        version: String,
        categoryName: String,
        extraInfo: [String: String]
    ) -> AnyPublisher<(status: UpdateStatus, versionInfo: VersionInfo?), ATErrorV2> {
        let request = VersionRequest(
            applicationName: applicationName,
            categoryName: categoryName,
            currentApplicationVersion: version,
            extraInfo: extraInfo
        )

        return ATRequestV2(
            url: urls.checkVersion,
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(CheckVersionResponse.self)
        .tryMap { response in
            guard let status = response.updateStatus else {
                throw ATErrorV2(errorType: .serialization)
            }
            return status
        }
        .mapError(ATErrorV2.from)
        .flatMap { status
            -> AnyPublisher<(status: UpdateStatus, versionInfo: VersionInfo?), ATErrorV2> in
            guard status != .notRequired else {
                return Just((status: status, versionInfo: nil))
                    .setFailureType(to: ATErrorV2.self)
                    .eraseToAnyPublisher()
            }

            return getLastVersion(request)
                .map { versionInfo in
                    (status: status, versionInfo: Optional(versionInfo))
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    func getLastVersion(
        applicationName: String,
        version: String,
        categoryName: String,
        extraInfo: [String: String]
    ) -> AnyPublisher<VersionInfo, ATErrorV2> {
        getLastVersion(
            VersionRequest(
                applicationName: applicationName,
                categoryName: categoryName,
                currentApplicationVersion: version,
                extraInfo: extraInfo
            )
        )
    }

    private func getLastVersion(
        _ request: VersionRequest
    ) -> AnyPublisher<VersionInfo, ATErrorV2> {
        ATRequestV2(
            url: urls.getLastVersion,
            parameters: request,
            configuration: configuration
        )
        .valuePublisher(VersionInfo.self)
    }
}
