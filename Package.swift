// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "ColorBurst",
                      platforms: [
                        .iOS(.v17)
                      ],
                      products: [
                        .library(name: "ColorBurst", targets: ["ColorBurst"]),
                      ],
                      targets: [
                        .target(name: "ColorBurst"),
                      ])
