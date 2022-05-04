// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaaS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MaaS",
            targets: ["MaaS"]),
    ],
    dependencies: [
        //.package(name: "MMCoreNetwork", url: "https://github.com/MosMetro-official/MMCoreNetwork", .exactItem("0.0.3-callbacks")),
        .package(name: "MMCoreNetwork", url: "https://github.com/MosMetro-official/MMCoreNetwork", .exactItem(Version("0.0.3-callbacks"))),
        //.package(name: "CoreTableView", url: "https://github.com/MosMetro-official/CoreTableView", from: "0.0.6"),
        .package(url: "https://github.com/MosMetro-official/CoreTableView", from: "0.0.6")
        
    ],
    targets: [
        .target(
            name: "MaaS",
            dependencies: [
                "MMCoreNetwork",
                "CoreTableView"
            ],
            resources: [
                .copy("Fonts/MoscowSans-Bold.otf"),
                .copy("Fonts/MoscowSans-Regular.otf"),
                .copy("Fonts/MoscowSans-Medium.otf"),
                .copy("Fonts/Comfortaa.ttf")
            ]
        ),
        .testTarget(
            name: "MaaSTests",
            dependencies: ["MaaS"]
        ),
    ]
)
