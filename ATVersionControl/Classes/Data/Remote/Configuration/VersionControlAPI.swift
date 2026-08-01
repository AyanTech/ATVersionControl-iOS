//
//  VersionControlAPI.swift
//  ATVersionControl
//

@MainActor
enum VersionControlAPI {
    static var checkVersionURL: String {
        versionControlBaseURL + "CheckVersion"
    }

    static var getLastVersionURL: String {
        versionControlBaseURL + "GetLastVersion"
    }

    static func apply(endpoints: [ColocationEndpoint]) {
        versionControlBaseURL = endpoints
            .first(where: { $0.name == "VersionControl" })?
            .baseURL ?? defaultBaseURL
    }

    static func reset() {
        versionControlBaseURL = defaultBaseURL
    }

    static let iranColocationURL = defaultBaseURL + "GetApplicationColocationConfig"
    static let internationalColocationURL = internationalBaseURL + "GetApplicationColocationConfig"

    private static let defaultBaseURL = "https://versioncontrol.infra.ayantech.ir/WebServices/App.svc/"
    private static let internationalBaseURL = "https://versioncontrol.infra.ayanco.com/WebServices/App.svc/"
    private static var versionControlBaseURL = defaultBaseURL
}
