// swift-tools-version:5.5

//
//  Package.swift
//
//
//  Created by Sander van Tulden on 12/10/2023.
//

import PackageDescription

let packageName = "Stuff"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v8),
        .watchOS(.v2),
        .macOS(.v10_10),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: packageName,
            targets: [packageName]
        )
    ],
    targets: [
        .target(
            name: packageName,
            path: "Source"
        ),
        .testTarget(
            name: packageName + "Tests",
            dependencies: [.target(name: packageName)],
            path: "StuffTests"
        )
    ]
)
