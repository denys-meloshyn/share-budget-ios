# Uncomment the next line to define a global platform for your project
platform :ios, '10.2'
source 'https://github.com/CocoaPods/Specs.git'

# ignore all warnings from all pods
inhibit_all_warnings!

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

target 'ShareBudget' do
	pod 'XCGLogger', '6.0.1'
	pod 'KeychainSwift', '10.0.0'
	pod 'R.swift', '4.0'
	pod 'SnapKit', '4.0'
	pod 'CorePlot', '2.2'
	pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
	pod 'le', '1.1'
	pod 'BugfenderSDK', '1.5.0'
	pod 'JustLog', '2.0.1'
	pod 'Toast-Swift', '3.0.1'
	pod 'SwiftLint', '0.24.2'
	pod 'Firebase/Core', '4.10.1'
	pod 'Crashlytics', '3.10.1'
	
	target 'ShareBudgetDevelopmentLocal' do
	# 	inherit! :search_paths
	end
	
	target 'ShareBudgetDevelopmentRemote' do
	# 	inherit! :search_paths
	end
	
	target 'ShareBudgetTests' do
# 		inherit! :search_paths
		pod 'Nimble', '7.0.3'
		pod 'Firebase/Core', '4.10.1'
	end
end

# Manually making compiler version be swift 3.2
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Toast-Swift'
            print "\t - Changing "
            print target.name
            print " swift version to 3.2\n"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
