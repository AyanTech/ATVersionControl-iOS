# ATVersionControl

##### Check the latest version of app with AyanTech servers<span style="color:red;">*</span>


<span style="color:red;">*</span> *app should be registered in AyanTechServers*

## Usage

To configure the parameters use this:
```swift
VersionControl.shared.applicationName = "MyAppName"
VersionControl.shared.categoryName = "cat"
VersionControl.shared.version = "1.0.0" //default version is CFBundleShortVersionString
VersionControl.shared.extraInfo["Token"] = "Test" //Json object and optional
```

## Installation

ATVersionControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATVersionControl'
```

## Author

Sepehr  Behroozi, 3pehrbehroozi@gmail.com
