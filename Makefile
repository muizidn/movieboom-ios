bzl_appcode_build:
	/usr/local/bin/bazel \
		build //:BazelAppDev \
		--verbose_failures \
		--bes_outerr_buffer_size=0 \
		--apple_generate_dsym \
		--apple_platform_type=ios \
		--cpu=ios_arm64 \
		--watchos_cpus=armv7k,arm64_32 \
		--announce_rc '--override_repository=tulsi=/Users/muis/Library/Application Support/Tulsi/0.20200819.88/Bazel' \
		--compilation_mode=dbg \
		--define=apple.add_debugger_entitlement=1 \
		--define=apple.propagate_embedded_extra_outputs=1 \
		--define=apple.experimental.tree_artifact_outputs=1 \
		--features=debug_prefix_map_pwd_is_dot \
		--tool_tag=tulsi:bazel_build \
		--build_event_json_file=/Users/muis/Desktop/BazelAppDev/BazelAppDev.xcodeproj/.tulsi/97827_build_events.json \
		--noexperimental_build_event_json_file_path_conversion \
		--aspects @tulsi//:tulsi/tulsi_aspects.bzl%tulsi_outputs_aspect \
		--output_groups=tulsi_outputs,default

bzl_xcode_build:
	/usr/local/bin/bazel \
		build //:BazelAppDevApp\
		--verbose_failures \
		--bes_outerr_buffer_size=0 \
		--apple_generate_dsym \
		--apple_platform_type=ios \
		--cpu=ios_arm64 \
		--watchos_cpus=armv7k,arm64_32 \
		--compilation_mode=dbg \
		--define=apple.add_debugger_entitlement=1 \
		--define=apple.propagate_embedded_extra_outputs=1 \
		--define=apple.experimental.tree_artifact_outputs=1 \
		--features=debug_prefix_map_pwd_is_dot \
		--noexperimental_build_event_json_file_path_conversion \
		--output_groups=tulsi_outputs,default

bzl_pod_update:
	bazel run @rules_pods//:update_pods -- --src_root ${PWD}