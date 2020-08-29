bzl_release_build: plist_increase_cfbundleversion bzl_xcode_build

bzl_ipa_build: bzl_xcode_build

bzl_xcode_build:
	/usr/local/bin/bazel \
		build //MovieBOOM:MovieBOOMApp \
		--verbose_failures \
		--bes_outerr_buffer_size=0 \
		--apple_generate_dsym \
		--apple_platform_type=ios \
		--ios_multi_cpus=arm64 \
		--watchos_cpus=armv7k,arm64_32 \
		--compilation_mode=opt \
		--define=apple.propagate_embedded_extra_outputs=1 \
		--features=debug_prefix_map_pwd_is_dot \
		--noexperimental_build_event_json_file_path_conversion \
		--output_groups=tulsi_outputs,default

bzl_build:
	bazel build //MovieBOOM:MovieBOOMApp

bzl_pod_update:
	bazel run @rules_pods//:update_pods -- --src_root ${PWD}

tools_setup:
	gem install cocoapods-rome

pod_dependency:
	pod install
	
pod_rome_list_fw_bazel:
	ls -1 Rome | sed 's/\(.*\).framework/"\/\/Vendor\/\1:\1",/'

buildnumber = $(shell expr `/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" MovieBOOM/Info.plist` + 1)
plist_increase_cfbundleversion:
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildnumber}" MovieBOOM/Info.plist
