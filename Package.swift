import PackageDescription

let package = Package(
    name: "LangKit",
    targets:
    [
        Target(
            name: "LangKit"
        ),
        Target(
            name: "LangKitDemo",
            dependencies: [ "LangKit" ]
        )
    ],
    dependencies:
    [
        .Package(url: "https://github.com/rxwei/CommandLine", majorVersion: 3, minor: 0),
    ],
    
    
    exclude: ["Documentation", "Build", "Frameworks", "Examples", "LangKit-iOS"]
)
