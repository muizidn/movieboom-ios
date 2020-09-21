# Generate frameworks using CocoaPods Rome
# After compile then write BUILD.bazel file
# if MACH_O_TYPE = 'staticlib' we use apple_static_framework_import
# default apple_dynamic_framework_import


# Set the platform globally
platform :ios, '12.0'

def get_all_generated_framework
    fws = %x(ls -1 Rome | grep framework)
    fws.split("\n").map { |fw| fw.match(/(.*).framework/)[1] }
end

# type: dynamic, static
def decl_apple_framework_import(fw, type)
<<-fw_decl
apple_#{type}_framework_import(
    name = "#{fw}",
    framework_imports = glob(["#{fw}.framework/**"]),
    visibility = ["//visibility:public"]
)
fw_decl
end

$staticlibs = []

plugin 'cocoapods-rome', 
    :pre_compile => Proc.new { |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                if config.build_settings['MACH_O_TYPE'] == 'staticlib'
                    $staticlibs.push config.build_settings['PRODUCT_NAME']
                end
                config.build_settings['SWIFT_VERSION'] = '5.0'
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
        installer.pods_project.save
    }, 
    :post_compile => Proc.new { |installer|
        File.open("Rome/BUILD.bazel", "w") { |buildfile|
            
            buildfile.puts 'load("@build_bazel_rules_apple//apple:apple.bzl","apple_dynamic_framework_import", "apple_static_framework_import")'
            buildfile.puts

            fwnames = get_all_generated_framework

            fwnames.each do | fw |
                if $staticlibs.include? fw
                    buildfile.puts decl_apple_framework_import(fw, 'static')
                else
                    buildfile.puts decl_apple_framework_import(fw, 'dynamic')
                end
            end
        }
    },
    dsym: false,
    configuration: 'Release'

plugin 'cocoapods-keys', {
  :project => "MovieBOOM",
  :keys => [
    "TMDBApiKey",
  ]}

install! 'cocoapods', integrate_targets: false

target 'MovieBOOM' do
    pod "GONMarkupParser"
end


