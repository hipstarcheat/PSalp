// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PSalp",
    platforms: [
        .iOS(.v16)  // Минимальная версия iOS
    ],
    products: [
        .executable(
            name: "Main",
            targets: ["App"]
        )
    ],
    dependencies: [
        // Добавьте зависимости, если они нужны
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [],
            path: "Sources/App"  // Путь к исходным файлам
        )
    ]
)
