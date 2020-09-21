load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "MovieBOOMThrift",
    module_name = "MovieBOOMThrift",
    srcs = glob([
        "Pods/MovieBOOMThrift/**/*.swift"
    ]),
    visibility = [
        "//MovieBOOM:__pkg__"
    ],
    deps = [
        "//Vendor/Thrift"
    ]
)