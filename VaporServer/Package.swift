// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "VaporServer",
    products: [
        .library(name: "VaporServer", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        .package(url: "https://github.com/mongodb/mongo-swift-driver.git", from: "0.1.3")
    ],
    targets: [
        .target(name: "App", dependencies: ["MongoSwift","FluentSQLite", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

