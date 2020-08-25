# Set the platform globally
platform :ios, '12.0'

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
            
            buildfile.write 'load("//config:custom_rules.bzl", "prebuilt_dynamic_framework")\n\n'

            fwnames = []

            installer.pods_project.targets.each do |target|
                buildfile.write <<-decl_prebuilt_binary_framework
                    prebuilt_dynamic_framework(
                        name = "#{target.name}",
                        path = "#{target.name}.framework",
                    )
                decl_prebuilt_binary_framework

                fwnames.push(target.name)
            end
        }
    },
    dsym: false,
    configuration: 'Release'

# Only download the files, don't create Xcode projects
install! 'cocoapods', integrate_targets: false

target 'MovieBOOM' do
  pod "Firebase/Analytics"
  pod "RxSwift"
  pod "RxCocoa"
  pod "RxRelay"
  pod "TinyConstraints"
  pod "Nimble"
end

