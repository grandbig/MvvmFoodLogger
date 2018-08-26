# Podfile
use_frameworks!
platform :ios, '11.0'

target "MvvmFoodLogger" do
  # Normal libraries
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'R.swift'

  abstract_target 'Tests' do
    target "MvvmFoodLoggerTests"
    target "MvvmFoodLoggerUITests"
  end
end
