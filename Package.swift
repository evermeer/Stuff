// swift-tools-version:5.5
//
//  Package.swift
//
//
//  Created by Sander van Tulden on 12/10/2023.
//

import PackageDescription

let packageName = "Stuff"
let packageNameAll = packageName + "-All"
let packageNamePrint = packageName + "-Print"
let packageNameEnum = packageName + "-Enum"
let packageNameTodo = packageName + "-TODO"
let packageNameCoding = packageName + "-Coding"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v8),
        .watchOS(.v2),
        .macOS(.v10.10),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: packageNameAll,
            targets: [packageNameAll]
        ),
        .library(
            name: packageNamePrint,
            targets: [packageNamePrint]
        ),
        .library(
            name: packageNameEnum,
            targets: [packageNameEnum]
        ),
        .library(
            name: packageNameTodo,
            targets: [packageNameTodo]
        ),
        .library(
            name: packageNameCoding,
            targets: [packageNameCoding]
        ),
    ],
    dependencies: [
        // Stub
    ],
    targets: [
        .target(
            name: packageNameAll,
            path: "Source"
        ),
        .target(
            name: packageNamePrint,
            path: "Source/Print"
        ),
        .target(
            name: packageNameEnum,
            path: "Source/Enum"
        ),
        .target(
            name: packageNameTodo,
            path: "Source/TODO"
        ),
        .target(
            name: packageNameCoding,
            path: "Source/Codable"
        ),
        .testTarget(
            name: packageName + "Tests",
            dependencies: [packageNameAll],
            path: "StuffTests"
        )
    ]
)
