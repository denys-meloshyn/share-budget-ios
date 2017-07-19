# Uncomment the next line to define a global platform for your project
platform :ios, '10.2'

def developing_pods
    pod 'XCGLogger', '~> 5.0.1'
    pod 'KeychainSwift', '~> 8.0'
    pod 'R.swift', '~> 3.2'
    pod 'SnapKit', '~> 3.2'
    pod 'CorePlot', '~> 2.2'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'le', '~> 1.1'
    pod 'BugfenderSDK', '~> 1.4.5'
end

target 'ShareBudget' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShareBudget
  developing_pods
  
  target 'ShareBudgetDevelopmentLocal' do
      inherit! :search_paths
      developing_pods
  end
  
  target 'ShareBudgetDevelopmentRemote' do
      inherit! :search_paths
      developing_pods
  end

  target 'ShareBudgetTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble', '~> 6.0.0'
  end

  target 'ShareBudgetUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
