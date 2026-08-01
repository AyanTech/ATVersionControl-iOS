//
//  UpdateDialogPresenter.swift
//  ATVersionControl
//

import UIKit

@MainActor
enum UpdateDialogPresenter {
    static func present(
        updateStatus: UpdateStatus,
        versionInfo: VersionInfo,
        onOptionalRejection: @MainActor @escaping () -> Void
    ) {
        let message = versionInfo.body + "\n" + versionInfo.changeLogs.joined(separator: "\n")
        let alertController = UIAlertController(
            title: versionInfo.title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(
            makeAcceptAction(
                updateStatus: updateStatus,
                versionInfo: versionInfo
            )
        )
        alertController.addAction(
            makeRejectAction(
                updateStatus: updateStatus,
                title: versionInfo.rejectButtonText,
                onOptionalRejection: onOptionalRejection
            )
        )

        TopViewControllerProvider.topViewController()?.present(
            alertController,
            animated: true
        )
    }

    private static func makeAcceptAction(
        updateStatus: UpdateStatus,
        versionInfo: VersionInfo
    ) -> UIAlertAction {
        UIAlertAction(title: versionInfo.acceptButtonText, style: .default) { _ in
            guard
                let url = URL(string: versionInfo.link),
                UIApplication.shared.canOpenURL(url)
            else {
                return
            }

            UIApplication.shared.open(url)

            guard updateStatus == .mandatory else {
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                exit(0)
            }
        }
    }

    private static func makeRejectAction(
        updateStatus: UpdateStatus,
        title: String,
        onOptionalRejection: @MainActor @escaping () -> Void
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: .destructive) { _ in
            if updateStatus == .mandatory {
                exit(0)
            } else {
                onOptionalRejection()
            }
        }
    }
}
