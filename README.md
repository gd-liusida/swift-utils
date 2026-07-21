# SDSwiftUtils

轻量、无第三方依赖的 Swift 工具库，支持 CocoaPods 和 Swift Package Manager。

## CocoaPods

```ruby
platform :ios, '13.0'
use_frameworks!

pod 'SDSwiftUtils', '~> 0.1.2'
```

然后运行 `pod install`，并在代码中导入：

```swift
import SDSwiftUtils
```

## Swift Package Manager

在 Xcode 中添加：

```text
https://github.com/gd-liusida/swift-utils.git
```

## 示例

```swift
let value = ["a", "b"][safe: 3] // nil
let blank = Optional<String>.none.isNilOrBlank // true
```

### 日志

```swift
SDLog.debug("debug message")
SDLog.info("application started")
SDLog.warning("low disk space")
SDLog.error("request failed")
```

## License

Apache License 2.0
