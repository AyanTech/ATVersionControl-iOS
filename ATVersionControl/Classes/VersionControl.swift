//
//  VersionControl.swift
//  ATVersionControl
//

import AyanTechNetworkingLibrary
import Foundation

@MainActor
open class VersionControl {
    fileprivate static var instance: VersionControl?

    public static var shared: VersionControl {
        if instance == nil {
            instance = VersionControl()
        }
        return instance!
    }

    public var applicationName = ""
    public var version = ""
    public var categoryName = ""
    public var extraInfo: [String: String] = [:]
    public var networkingConfiguration: ConfigurationV2 = .init(timeout: 30)
    public weak var delegate: VersionControlDelegate?

    let legacyState = LegacyVersionControlState()

    public init() {
        version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }

    public static func useShared(_ versionControl: VersionControl) {
        instance = versionControl
    }

    open func showUpdateDialog(
        updateStatus: UpdateStatus,
        versionInfo: VersionInfo
    ) {
        UpdateDialogPresenter.present(
            updateStatus: updateStatus,
            versionInfo: versionInfo,
            onOptionalRejection: {
                self.delegate?.versionControlCompletedSuccessfully()
            }
        )
    }
}
