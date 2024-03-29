#
#  Be sure to run `pod spec lint ZRefreshing.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZRefreshing"
  s.version      = "1.3.1"
  s.summary      = "ZRefreshing is a simple swift Refreshing Control."

  s.description  = <<-DESC
    ZRefreshing is a simple and pure swift Refreshing Control for Tableview or CollectionView.
                   DESC

  s.homepage     = "https://github.com/zevwings/ZRefreshing"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zevwings" => "zev.wings@gmail.com" }
  s.source       = { :git => "https://github.com/zevwings/ZRefreshing.git", :tag => "#{s.version}" }
  s.source_files = "ZRefreshing/**/*.swift", "ZRefreshing/ZRefreshing.h"
  s.resources    = "ZRefreshing/ZRefreshing.bundle"
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = "8.0"

end
