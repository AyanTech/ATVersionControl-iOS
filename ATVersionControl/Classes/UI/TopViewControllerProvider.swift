//
//  TopViewControllerProvider.swift
//  ATVersionControl
//

import UIKit

@MainActor
enum TopViewControllerProvider {
    static func topViewController() -> UIViewController? {
        var topController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController

        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }

        return topController
    }
}
