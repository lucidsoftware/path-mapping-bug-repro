workspace(name = "path_mapping_bug_repro")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules_java
http_archive(
    name = "rules_java",
    sha256 = "dfbadbb37a79eb9e1cc1e156ecb8f817edf3899b28bc02410a6c1eb88b1a6862",
    urls = [
        "https://github.com/bazelbuild/rules_java/releases/download/7.12.1/rules_java-7.12.1.tar.gz",
    ],
)

load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")

rules_java_dependencies()

register_toolchains("//:repository_default_toolchain_21_definition")