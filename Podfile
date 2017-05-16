# Uncomment the next line to define a global platform for your project
platform :ios, '10.2'

target 'ShareBudget' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShareBudget
  pod 'XCGLogger'
  pod 'KeychainSwift'
  pod 'R.swift'
  pod 'SnapKit'
  pod 'CorePlot'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'le', '~> 1.1'
  pod 'BugfenderSDK', '~> 1.4'

  target 'ShareBudgetTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Cuckoo', '~> 0.9'
  end

  target 'ShareBudgetUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
