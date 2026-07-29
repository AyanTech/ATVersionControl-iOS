//
//  VersionControl.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/5/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import UIKit
import AyanTechNetworkingLibrary

@MainActor
public protocol VersionControlDelegate: AnyObject {
    func versionControlCompletedSuccessfully()
    func versionControlDidFinish(with error: String)
}

@MainActor
open class VersionControl {
    fileprivate static var instance: VersionControl?
    
    public var applicationName = ""
    public var version = ""
    public var categoryName = ""
    public var extraInfo: [String: String] = [:]
    public var networkingConfiguration: ConfigurationV2 = .init(timeout: 30)
    public weak var delegate: VersionControlDelegate?
    
    private var updateStatus: UpdateStatus = .notRequired
    private var isResolvingEndpoints = false
    
    public static var shared: VersionControl {
        if instance == nil {
            instance = VersionControl()
        }
        return instance!
    }
    
    public static func useShared(_ versionControl: VersionControl) {
        instance = versionControl
    }
    
    public init() {
        version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    public func getEndpoints(completion: @escaping (GetEndpointsResult) -> Void) {
        guard !isResolvingEndpoints else {
            DispatchQueue.main.async {
                completion(.failure)
            }
            return
        }
        isResolvingEndpoints = true
        ColocationResolver.resolve(applicationName: applicationName, version: version) { [weak self] result in
            self?.isResolvingEndpoints = false
            completion(result)
        }
    }
    
    public func shareAppLink(_ completionHandler: @escaping (ATError?) -> Void) {
        self.getLastVersion { (versionInfo, error) in
            if let textToShare = versionInfo?.textToShare {
                let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                Utils.getTopMostViewController()?.present(activity, animated: true)
                completionHandler(nil)
            } else {
                completionHandler(error ?? .generalError)
            }
        }
    }
    
    public func checkVersion(delegate: VersionControlDelegate? = nil) {
        if let delegate {
            self.delegate = delegate
        }

        ATRequest.request(url: ATUrl.checkVersion, method: .post)
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
                    guard let self else { return }
                    self.handleCheckVersionResponse(response)
                }
            }
    }
    
    private func handleCheckVersionResponse(_ response: ATResponse) {
        if response.isSuccess {
            if let updateStatusValue = response.parametersJsonObject?["UpdateStatus"] as? String,
               let updateStatus = UpdateStatus(rawValue: updateStatusValue),
               updateStatus != .notRequired {
                self.getLastVersion() { versionInfo, error in
                    if let info = versionInfo {
                        self.showUpdateDialog(updateStatus: updateStatus, versionInfo: info)
                    } else {
                        self.delegate?.versionControlDidFinish(with: error?.persianDescription ?? "خطا در برقراری ارتباط با سرور")
                    }
                }
            } else {
                self.delegate?.versionControlCompletedSuccessfully()
            }
        } else {
            self.delegate?.versionControlDidFinish(with: response.error?.persianDescription ?? "خطا در برقراری ارتباط با سرور")
        }
    }
    
    private func getLastVersion(
        _ completionHandler: (@MainActor (VersionInfo?, ATError?) -> Void)? = nil
    ) {
        ATRequest.request(url: ATUrl.getLastVersion, method: .post)
        .setJsonBody(body: [
            "Parameters": [
                "ApplicationName": self.applicationName,
                "ApplicationType": "ios",
                "CategoryName": self.categoryName,
                "CurrentApplicationVersion": self.version,
                "ExtraInfo": self.extraInfo
            ]
        ], ignoreParameterCreator: true)
            .send { response in
                MainActor.assumeIsolated {
                    if let versionInfo = VersionInfo.from(json: response.parametersJsonObject) {
                        completionHandler?(versionInfo, nil)
                    } else {
                        completionHandler?(nil, response.error ?? .generalError)
                    }
                }
        }
    }
    
    open func showUpdateDialog(updateStatus: UpdateStatus, versionInfo: VersionInfo) {
        let dialogMessage = versionInfo.body + "\n" + versionInfo.changeLogs.joined(separator: "\n")
        
        let alertController = UIAlertController(title: versionInfo.title, message: dialogMessage, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: versionInfo.acceptButtonText, style: .default) { _ in
            if let url = URL(string: versionInfo.link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                if updateStatus == .mandatory {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        exit(0)
                    }
                }
            }
        }
        
        let rejectAction = UIAlertAction(title: versionInfo.rejectButtonText, style: .destructive) { _ in
            if updateStatus == .mandatory {
                exit(0)
            } else {
                self.delegate?.versionControlCompletedSuccessfully()
            }
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(rejectAction)
        
        if let topViewController = Utils.getTopMostViewController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
