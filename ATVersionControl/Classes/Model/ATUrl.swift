//
//  ATURL.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation

@MainActor
class ATUrl {
    static let defaultVersionControlBaseURL = "https://versioncontrol.infra.ayantech.ir/WebServices/App.svc/"
    static let internationalVersionControlBaseURL = "https://versioncontrol.infra.ayanco.com/WebServices/App.svc/"

    static var versionControlBaseURL = defaultVersionControlBaseURL

    class var checkVersion: String {
        return versionControlBaseURL + "CheckVersion"
    }

    class var getLastVersion: String {
        return versionControlBaseURL + "GetLastVersion"
    }

    class var iranGetApplicationColocationConfig: String {
        return defaultVersionControlBaseURL + "GetApplicationColocationConfig"
    }

    class var internationalGetApplicationColocationConfig: String {
        return internationalVersionControlBaseURL + "GetApplicationColocationConfig"
    }
}
