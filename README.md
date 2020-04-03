# BRIck

## Installation
---

### Swift Package Manager

You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring **BRIck** as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/gorillka/BRIck", from: "2.0.1")
```

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

### Carthage

To integrate BRIck into your Xcode project using Carthage, specify it in your `Cartfile`:
```
github "https://github.com/gorillka/BRIck" ~> 2.0.1
```

### CocoaPods

To integrate BRIck into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BRI', '~> 2.0.1'
end
```

## BRIck Xcode Templates

### Installation
---

Run the `install-xcode.template.sh` shell script to copy the templates to the Xcode templates folder. Once you have successfully copied the templates, when adding a new file in Xcode, the BRIck group will show up.