#
# Be sure to run `pod lib lint ATVersionControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATVersionControl'
  s.version          = '0.1.0'
  s.summary          = 'Version control library for AyanTech iOS apps'
  s.description      = <<-DESC
Library to check for new version of app with AyanTech servers
                       DESC
  s.homepage         = 'https://github.com/AyanTech/ATVersionControl-iOS.git'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author           = { 'Sepehr  Behroozi' => '3pehrbehroozi@gmail.com' }
  s.source           = { :git => 'https://github.com/AyanTech/ATVersionControl-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3pehrbehroozi'

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.0"
  s.source_files = 'ATVersionControl/Classes/**/*'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'SwiftBooster'
  s.dependency 'PopupDialog'
  s.dependency 'AyanTechNetworkingLibrary'
end
