import ProjectDescription

let project = Project(
    name: "OvoTimer",
    targets: [
        .target(
            name: "OvoTimer",
            destinations: Set([.iPad, .iPad, .appleVisionWithiPadDesign, .macWithiPadDesign]),
            product: .app,
            bundleId: "com.departamento-b.OvoTimer",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["OvoTimer/Sources/**"],
            resources: ["OvoTimer/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "OvoTimerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.OvoTimerTests",
            infoPlist: .default,
            sources: ["OvoTimer/Tests/**"],
            resources: [],
            dependencies: [.target(name: "OvoTimer")]
        ),
    ]
)
