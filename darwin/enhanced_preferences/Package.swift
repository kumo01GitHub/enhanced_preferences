// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "enhanced_preferences",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],
    products: [
        .library(name: "enhanced-preferences", targets: ["enhanced_preferences"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "enhanced_preferences",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
