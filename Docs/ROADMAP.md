# Roadmap

This is a suggested roadmap for future work. It does not describe the current version.

## Next major version

The next major version should use Networking V2 and Combine as the main implementation while keeping the package simple.

### Legacy code to remove

- Remove `checkVersion(delegate:)`, `getEndpoints(completion:)`, and `shareAppLink(_:)` after their backward-compatibility period.
- Remove the private callback-based `getLastVersion` implementation.
- Remove `VersionControlDelegate` and its `delegate` property.
- Remove Networking V1 requests and related files.
- Remove `Colocation.swift` and `GetEndpointsResultEnum.swift`.
- Remove `from(json:)` and `from(response:)` helpers after Networking V1 is removed.

### Publishers and UI

- Keep `checkVersionPublisher()`, `getLastVersionPublisher()`, `getEndpointsPublisher()`, and `shareAppLinkPublisher()`.
- Rename these methods to remove the `Publisher` suffix because publishers will be the only source.
- Keep data publishers focused on returning data and remove dialog presentation from them.
- Move optional update dialogs and share sheets to a separate UI convenience layer.

