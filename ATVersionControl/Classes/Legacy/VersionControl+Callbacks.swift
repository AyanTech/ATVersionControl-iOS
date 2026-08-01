//
//  VersionControl+Callbacks.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Foundation

public extension VersionControl {
    func checkVersion(delegate: VersionControlDelegate? = nil) {
        if let delegate {
            self.delegate = delegate
        }

        ATRequest.request(
            url: VersionControlAPI.checkVersionURL,
            method: .post
        )
        .setJsonBody(
            body: [
                "Parameters": [
                    "ApplicationName": applicationName,
                    "ApplicationType": "ios",
                    "CategoryName": categoryName,
                    "CurrentApplicationVersion": version,
                    "ExtraInfo": extraInfo
                ]
            ],
            ignoreParameterCreator: true
        )
        .send { [weak self] response in
            MainActor.assumeIsolated {
                self?.handleCheckVersionResponse(response)
            }
        }
    }

    func getEndpoints(completion: @escaping (GetEndpointsResult) -> Void) {
        guard !legacyState.isResolvingEndpoints else {
            DispatchQueue.main.async {
                completion(.failure)
            }
            return
        }

        legacyState.isResolvingEndpoints = true
        LegacyColocationResolver.resolve(
            applicationName: applicationName,
            version: version
        ) { [weak self] result in
            self?.legacyState.isResolvingEndpoints = false
            completion(result)
        }
    }

    func shareAppLink(_ completionHandler: @escaping (ATError?) -> Void) {
        getLastVersion { versionInfo, error in
            guard let textToShare = versionInfo?.textToShare else {
                completionHandler(error ?? .generalError)
                return
            }

            ShareSheetPresenter.present(text: textToShare)
            completionHandler(nil)
        }
    }

    private func handleCheckVersionResponse(_ response: ATResponse) {
        guard response.isSuccess else {
            delegate?.versionControlDidFinish(
                with: response.error?.persianDescription ?? "خطا در برقراری ارتباط با سرور"
            )
            return
        }

        guard
            let updateStatusValue = response.parametersJsonObject?["UpdateStatus"] as? String,
            let updateStatus = UpdateStatus(rawValue: updateStatusValue),
            updateStatus != .notRequired
        else {
            delegate?.versionControlCompletedSuccessfully()
            return
        }

        getLastVersion { versionInfo, error in
            guard let versionInfo else {
                self.delegate?.versionControlDidFinish(
                    with: error?.persianDescription ?? "خطا در برقراری ارتباط با سرور"
                )
                return
            }

            self.showUpdateDialog(
                updateStatus: updateStatus,
                versionInfo: versionInfo
            )
        }
    }

    private func getLastVersion(
        _ completionHandler: (@MainActor (VersionInfo?, ATError?) -> Void)? = nil
    ) {
        ATRequest.request(
            url: VersionControlAPI.getLastVersionURL,
            method: .post
        )
        .setJsonBody(
            body: [
                "Parameters": [
                    "ApplicationName": applicationName,
                    "ApplicationType": "ios",
                    "CategoryName": categoryName,
                    "CurrentApplicationVersion": version,
                    "ExtraInfo": extraInfo
                ]
            ],
            ignoreParameterCreator: true
        )
        .send { response in
            MainActor.assumeIsolated {
                guard let versionInfo = VersionInfo.from(json: response.parametersJsonObject) else {
                    completionHandler?(nil, response.error ?? .generalError)
                    return
                }

                completionHandler?(versionInfo, nil)
            }
        }
    }
}
