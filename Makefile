bzl_release_build: plist_increase_cfbundleversion
	bazel build //MovieBOOM:MovieBOOMApp --config=release

bzl_ipa_release_build:
	bazel build //MovieBOOM:MovieBOOMApp --config=release

bzl_ipa_dev_build:
	bazel build //MovieBOOM:MovieBOOMApp --config=debug

bzl_podtobuild_update:
	bazel run @rules_pods//:update_pods -- --src_root ${PWD}

tools_setup:
	gem install cocoapods-rome

pod_dependency:
	pod install
	
pod_rome_list_fw_bazel:
	ls -1 Rome | sed 's/\(.*\).framework/"\/\/Vendor\/\1:\1",/'

buildnumber = $(shell expr `/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" MovieBOOM/Plist_Info.plist` + 1)
plist_increase_cfbundleversion:
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildnumber}" MovieBOOM/Plist_Info.plist

needle_generate:
	needle generate MovieBOOM/App_NeedleGenerated.swift MovieBOOM

rswift_generate:
	make -C tools/rswift generate
	mv tools/rswift/App_R.generated.swift MovieBOOM

thrift_pod_update:
	make -C thrift pod_update