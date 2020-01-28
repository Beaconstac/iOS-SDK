# EddystoneScanner-iOS-SDK

Eddystone Scanner is library written in Swift that scans for eddystone beacons and maintains a list of all the nearby beacons.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build EddystoneScanner.

To integrate EddystoneScanner into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'EddystoneScanner'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate EddystoneScanner into your project manually.

#### Embedded Framework

- Go to the releases [section](https://github.com/Beaconstac/EddystoneScanner-iOS-SDK/releases) and download the framework from the latest release.
> You'll see a file named EddystoneScanner.framework.zip. 
- Download the framwork and add it to your project.
- Do not forget to check 'Copy files if needed' checkbox.


## Background beacon scanning

To support background scanning of beacons add `bluetooth-central` to the apps `Info.plist` as one of the values for `UIBackgroundModes` array or just do it from the Capabilities section of the app.

![Xcode Capability Section](https://raw.githubusercontent.com/Beaconstac/EddystoneScanner-iOS-SDK/master/doc_images/background_scanning_capability.png)
