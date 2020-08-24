# Set the platform globally
platform :ios, '12.0'

plugin 'cocoapods-rome', { :pre_compile => Proc.new { |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end

    installer.pods_project.save
},

    dsym: false,
    configuration: 'Release'
}

# Only download the files, don't create Xcode projects
install! 'cocoapods', integrate_targets: false

target 'MovieBOOM' do
  pod "Firebase/Analytics"
  pod "RxSwift"
  pod "RxRelay"
  pod "TinyConstraints"
end

