// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SDSwiftUtils",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SDSwiftUtils", targets: ["SDSwiftUtils"])
    ],
    targets: [
        .target(name: "SDSwiftUtils"),
        .testTarget(name: "SDSwiftUtilsTests", dependencies: ["SDSwiftUtils"])
    ]
)
