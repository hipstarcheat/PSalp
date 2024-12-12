// swift-tools-version: 5.9



import PackageDescription
import AppleProductTypes

let package = Package(
    name: "PSalp",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "MyApp",
            targets: ["App"],
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.yellow),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            appCategory: .utilities
        )
    ],
    targets: [
        .executableTarget(
            name: "App",
            path: "Sources/App",  // Путь к исходным файлам
            resources: [
                .process("../Resources")  // Подключение папки ресурсов
            ]
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
