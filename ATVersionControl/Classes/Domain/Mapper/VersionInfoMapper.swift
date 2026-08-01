//
//  VersionInfoMapper.swift
//  ATVersionControl
//

enum VersionInfoMapper {
    static func map(_ dto: VersionInfoDTO) -> VersionInfo {
        var versionInfo = VersionInfo()
        versionInfo.acceptButtonText = dto.acceptButtonText
        versionInfo.body = dto.body
        versionInfo.changeLogs = dto.changeLogs
        versionInfo.link = dto.link
        versionInfo.linkType = dto.linkType
        versionInfo.rejectButtonText = dto.rejectButtonText
        versionInfo.textToShare = dto.textToShare
        versionInfo.title = dto.title
        return versionInfo
    }
}
