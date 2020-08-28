# Set the platform globally
platform :ios, '12.0'

def get_all_generated_framework
    fws = %x(ls -1 Rome | grep framework | sed 's/\(.*\).framework/\1/')
    fws.split("\n")
end

def decl_prebuilt_framework(fw)
<<-decl_prebuilt_binary_framework
    prebuilt_dynamic_framework(
        name = "#{fw}",
        path = "#{fw}.framework",
    )
decl_prebuilt_binary_framework
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
            
            buildfile.puts 'load("//config:custom_rules.bzl", "prebuilt_dynamic_framework")'
            buildfile.puts

            fwnames = get_all_generated_framework

            fwnames.each do | fw |
                buildfile.puts decl_prebuilt_framework(fw)
            end
        }
    },
    dsym: false,
    configuration: 'Release'

# Only download the files, don't create Xcode projects
install! 'cocoapods', integrate_targets: false

target 'MovieBOOM' do
  pod 'Moya'
  pod 'MidtransKit', '~> 1.15.3'
  pod "ViewDSL",
    :git => "https://github.com/muizidn/viewdsl",
    :branch => "master"
  pod "TinyConstraints"
  pod "RxSwift"
  pod "ReSwift"
  pod "RxCocoa"
  pod "R.swift"
  pod "Kingfisher"
  pod "CHIPageControl"
  pod "ImageSlideshow"
  pod 'AttributedLib', 
    :git => "https://github.com/muizidn/Attributed.git",
    :branch => "master"
  pod "IQKeyboardManager"
  pod "KeychainAccess"
  pod "Nantes"
  pod "Reachability"
  pod "DropDown"
  pod "Macaw"
  pod "SwiftyImage"
  pod "DifferenceKit"
  pod "JGProgressHUD"
  pod "XLPagerTabStrip"

  pod 'Nuke'
  pod 'MaterialComponents'
  pod 'JGProgressHUD'
  pod 'TinyConstraints'
  pod 'SwiftyJSON'
  pod 'NeedleFoundation'
  pod 'Firebase/Analytics'
  pod 'ReSwift'
  pod 'ReSwiftThunk'
  pod 'R.swift'
  pod 'NavigationDrawer',
    :git => "https://github.com/asisadh/NavigationDrawerSwift.git",
    :tag => "1.0.3"

  pod "PaperTrailLumberjack/Swift"
  pod 'Floaty', 
    :git => "https://github.com/muizidn/Floaty.git",
    :branch => "master"
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '5.1.0'
end

