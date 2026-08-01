//
//  VersionCheckResult.swift
//  ATVersionControl
//

struct VersionCheckResult: Sendable {
    let status: UpdateStatus
    let versionInfo: VersionInfo?
}
