# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'FedsDriver' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FedsDriver

use_frameworks!




source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.1'
pod 'GoogleMaps'

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
pod 'Alamofire', '~> 4.0'
pod 'AlamofireObjectMapper', '~> 4.0'

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!


platform :ios, '8.0'
use_frameworks!
pod “ACFloatingTextfield-Swift” , :git => 'https://github.com/ErAbhishekChandani/ACFloatingTextfield.git'
pod 'Eureka', '~> 2.0.0-beta.1'
pod "PromiseKit", "~> 4.0"
pod "PromiseKit/CoreLocation"
pod "PromiseKit/UIKit", "~> 4.0"


end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

