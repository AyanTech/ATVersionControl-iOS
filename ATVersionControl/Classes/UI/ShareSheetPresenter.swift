//
//  ShareSheetPresenter.swift
//  ATVersionControl
//

import UIKit

@MainActor
enum ShareSheetPresenter {
    static func present(text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )

        guard let viewController = TopViewControllerProvider.topViewController() else {
            return
        }

        activityViewController.popoverPresentationController?.sourceView = viewController.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(
            x: viewController.view.bounds.midX,
            y: viewController.view.bounds.midY,
            width: 0,
            height: 0
        )
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        viewController.present(activityViewController, animated: true)
    }
}
