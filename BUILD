load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "BazelAppDev",
    srcs = glob(["BazelAppDev/**/*.swift"]),
    data = glob(["BazelAppDev/**/*.storyboard"]),
)

ios_application(
    name = "BazelAppDevApp",
    bundle_id = "com.muiz.idn.bazelappdev",
    families = [
        "iphone",
        "ipad",
    ],
    minimum_os_version = "12.0",
    infoplists = [":BazelAppDev/Info.plist"],
    visibility = ["//visibility:public"],
    provisioning_profile = "dev.mobileprovision",
    deps = [":BazelAppDev"],
)
