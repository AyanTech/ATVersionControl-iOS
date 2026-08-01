//
//  VersionControlDelegate.swift
//  ATVersionControl
//

@MainActor
public protocol VersionControlDelegate: AnyObject {
    func versionControlCompletedSuccessfully()
    func versionControlDidFinish(with error: String)
}
