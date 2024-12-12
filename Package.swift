// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PSalp",
    platforms: [
        .iOS(.v15)  // Минимальная версия iOS
    ],
    products: [
        .executable(
            name: "MyApp",
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
