# Roadmap

This is a suggested roadmap for future work. It does not describe the current version.

## Next major version

- Delete the entire `Legacy` folder. This removes the callback APIs and Networking V1 implementation.
- Remove `delegate` and `legacyState` from `VersionControl` after deleting `Legacy`.
- Keep `VersionControl` as the public SDK entry point for configuration, shared access, and Combine APIs.
- Keep Combine as the main API and remove the `Publisher` suffix from method names.
- Remove dialog and share-sheet presentation from the core SDK.
- Keep Domain and Data independent from UIKit.
