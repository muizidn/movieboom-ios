# Set the platform globally
platform :ios, '12.0'

def get_all_generated_framework
    fws = %x(ls -1 Rome | grep framework)
    fws.split("\n").map { |fw| fw.match(/(.*).framework/)[1] }
end

def decl_apple_dynamic_framework(fw)
<<-decl_apple_dynamic_framework
apple_dynamic_framework_import(
    name = "#{fw}",
    framework_imports = glob(["#{fw}.framework/**"]),
    visibility = ["//visibility:public"]
)
decl_apple_dynamic_framework
end

plugin 'cocoapods-rome', 
    :pre_compile => Proc.new { |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
        installer.pods_project.save
    }, 
    :post_compile => Proc.new { |installer|
        File.open("Rome/BUILD.bazel", "w") { |buildfile|
            
            buildfile.puts 'load("@build_bazel_rules_apple//apple:apple.bzl","apple_dynamic_framework_import")'
            buildfile.puts

            fwnames = get_all_generated_framework

            fwnames.each do | fw |
                buildfile.puts decl_apple_dynamic_framework(fw)
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

# Only download the files, don't create Xcode projects
install! 'cocoapods', integrate_targets: false

target 'MovieBOOM' do
end


