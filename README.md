# ATVersionControl

##### Check the latest version of app with AyanTech servers<span style="color:red;">*</span>


<span style="color:red;">*</span> *app should be registered in AyanTechServers*

## Requirements

- iOS 13.0+
- Swift 6.0+
- Xcode 16.0+
- AyanTechNetworkingLibrary 2.x

## Usage

### Configuration

```swift
VersionControl.shared.applicationName = "MyAppName"
VersionControl.shared.categoryName = "cat"
VersionControl.shared.version = "1.0.0" // Defaults to CFBundleShortVersionString
VersionControl.shared.extraInfo["Token"] = "Test"
```

### Combine

Resolve the app endpoints first, then check its version. Keep each subscription alive until it completes:

```swift
import Combine

@MainActor
final class VersionControlFlow {
    private let versionControl = VersionControl.shared
    private var endpointsCancellable: AnyCancellable?
    private var versionCheckCancellable: AnyCancellable?

    func start() {
        resolveEndpoints()
    }

    private func resolveEndpoints() {
        endpointsCancellable?.cancel()

        endpointsCancellable = versionControl.getEndpointsPublisher()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        // Apply the app's default endpoint configuration.
                        print(error.message)
                    }
                    self?.checkVersion()
                },
                receiveValue: { endpoints in
                    // Apply the resolved endpoints to the app's services.
                    print(endpoints)
                }
            )
    }

    func checkVersion() {
        versionCheckCancellable?.cancel()

        versionCheckCancellable = versionControl.checkVersionPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Show an error or continue according to app requirements.
                        print(error.message)
                    }
                },
                receiveValue: { status in
                    switch status {
                    case .notRequired:
                        // Navigate to the app.
                        break
                    case .optional, .mandatory:
                        // The package presents the update dialog automatically.
                        break
                    }
                }
            )
    }
}
```

Endpoint resolution is optional. If the app does not use colocation discovery, call `checkVersion()` directly.

`checkVersionPublisher()` completes after presenting an optional or mandatory update dialog; it does not wait for the user's decision. Set `VersionControl.shared.delegate` to handle the current optional-update "Later" action.

### Latest version information

```swift
versionControl.getLastVersionPublisher()
    .sink(
        receiveCompletion: { print($0) },
        receiveValue: { versionInfo in
            print(versionInfo.title)
        }
    )
    .store(in: &cancellables)
```

### Share application

```swift
versionControl.shareAppLinkPublisher()
    .sink(
        receiveCompletion: { print($0) },
        receiveValue: { _ in }
    )
    .store(in: &cancellables)
```

`shareAppLinkPublisher()` automatically presents `UIActivityViewController`.

### Custom update UI (optional)

Call `useShared` once at app launch, before accessing `VersionControl.shared`. Override `showUpdateDialog` to replace the default alert.

```swift
final class AppVersionControl: VersionControl {
    override func showUpdateDialog(updateStatus: UpdateStatus, versionInfo: VersionInfo) {
        // Present custom update UI.
    }
}

VersionControl.useShared(AppVersionControl())
```

### Legacy compatibility

The callback APIs remain temporarily available for backward compatibility:

```swift
VersionControl.shared.checkVersion()

VersionControl.shared.getEndpoints { result in
    print(result)
}

VersionControl.shared.shareAppLink { error in
    print(error as Any)
}
```

## Installation

ATVersionControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATVersionControl'
```
