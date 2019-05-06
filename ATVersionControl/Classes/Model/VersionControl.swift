//
//  VersionControl.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/5/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation
import AyanTechNetworkingLibrary
import SwiftBooster
import PopupDialog

public class VersionControl {
    fileprivate static var instance: VersionControl?
    
    public var applicationName = ""
    public var version = ""
    public var categoryName = ""
    public var extraInfo = JSONObject()
    
    private var updateStatus: UpdateStatus = .notRequired
    
    public static var shared: VersionControl {
        if instance == nil {
            instance = VersionControl()
        }
        return instance!
    }
    
    private init() {
        version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
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
    
    public func checkVersion() {
        ATRequest.request(url: ATUrl.checkVersion, method: .post)
        .setJsonBody(body: [
            "ApplicationName":self.applicationName,
            "ApplicationType": "ios",
            "CategoryName": self.categoryName,
            "CurrentApplicationVersion": self.version,
            "ExtraInfo": self.extraInfo
        ])
        .send(responseHandler: handleCheckVersionResponse(_:))
    }
    
    private func handleCheckVersionResponse(_ response: ATResponse) {
        if let updateStatus = UpdateStatus(rawValue: getValue(input: response.parametersJsonObject, subscripts: "UpdateStatus") ?? ""), updateStatus != .notRequired {
            self.getLastVersion() { versionInfo, _ in
                if let info = versionInfo {
                    self.showUpdateDialog(updateStatus: updateStatus, versionInfo: info)
                }
            }
        }
    }
    
    private func getLastVersion(_ completionHandler: ((VersionInfo?, ATError?) -> Void)? = nil) {
        ATRequest.request(url: ATUrl.getLastVersion, method: .post)
        .setJsonBody(body: [
            "ApplicationName": self.applicationName,
            "ApplicationType": "ios",
            "CategoryName": self.categoryName,
            "CurrentApplicationVersion": self.version,
            "ExtraInfo": self.extraInfo
        ])
            .send { (response) in
                if let versionInfo = VersionInfo.from(json: response.parametersJsonObject) {
                    completionHandler?(versionInfo, nil)
                } else {
                    completionHandler?(nil, response.error ?? .generalError)
                }
        }
    }
    
    private func showUpdateDialog(updateStatus: UpdateStatus, versionInfo: VersionInfo) {
        var dialogMessage = versionInfo.body + "\n" + versionInfo.changeLogs.joined(separator: "\n")
        let dialog = PopupDialog(title: versionInfo.title, message: dialogMessage, tapGestureDismissal: updateStatus == .optional, panGestureDismissal: updateStatus == .optional)
        let acceptButton = PopupDialogButton.init(title: versionInfo.acceptButtonText, action: {
            if let url = URL(string: versionInfo.link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                if updateStatus == .mandatory {
                    doAfter(2.0) {
                        exit(0)
                    }
                }
            }
        })
        let rejectButton = PopupDialogButton.init(title: versionInfo.rejectButtonText, action: {
            if updateStatus == .mandatory {
                exit(0)
            }
        })
        
        rejectButton.setTitleColor(UIColor.red, for: .normal)
        dialog.addButton(acceptButton)
        dialog.addButton(rejectButton)
        Utils.getTopMostViewController()?.present(dialog, animated: true)
        
    }
}
