# Uncomment the next line to define a global platform for your project
platform :ios, '10.2'
source 'https://github.com/CocoaPods/Specs.git'

# ignore all warnings from all pods
inhibit_all_warnings!

def shared
  pod 'XCGLogger', '7.0.0'
  pod 'KeychainSwift', '11.0.0'
  pod 'R.swift', '5.0.3'
  pod 'SnapKit', '5.0.0'
  pod 'CorePlot', '2.2'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'le', '1.1'
  pod 'BugfenderSDK', '1.6.6'
  pod 'JustLog', '3.0.0'
  pod 'Toast-Swift', '5.0.0'
  pod 'SwiftLint', '0.33.1'
  pod 'Firebase/Core', '6.4.0'
  pod 'Crashlytics', '3.13.4'
  pod 'Sourcery', '0.16.1'
  pod 'TimeIntervals', '1.0.1'
  pod 'HTTPNetworking', :git => 'https://github.com/ned1988/HttpNetworking.git'
end

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

target 'ShareBudget' do
  shared
end

target 'ShareBudgetTests' do
  shared
  pod 'Nimble', '8.0.2'
end

target 'ShareBudgetUITests' do
  shared
end

# Manually making compiler version be swift 3.2
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    end

    if [].include? target.name
      print "\t - Changing "
      print target.name
      print " swift version to 4.2\n"
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end

      if target.name == 'CorePlot'
        config.build_settings['ALWAYS_SEARCH_USER_PATHS'] = 'NO'
      end
    end
  end
end

