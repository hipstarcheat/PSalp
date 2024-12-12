// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PSalp",
    platforms: [
        .iOS(.v16)  // Минимальная версия iOS
    ],
    products: [
        .executableTarget(
            name: "ContenView",
            targets: ["App"]
        )
    ],
    dependencies: [
        // Добавьте зависимости, если они нужны
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [],
            path: "Sources/App"  // Путь к исходным файлам
        )
    ]
)
