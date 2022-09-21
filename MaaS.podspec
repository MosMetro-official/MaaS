#
#  Be sure to run `pod spec lint MaaS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MaaS"
  spec.version      = "0.0.8"
  spec.summary      = "The MaaS module developed by the Moscow Metro."

  spec.description  = "A ready-made MaaS module for integrating the service into any project. You need to configure deep links and the authorization process (token)"

  spec.homepage     = "https://github.com/MosMetro-official/MaaS"

  spec.license      = "MIT"

  spec.author           = { 'vplatonovv' => 'slava.p12@yandex.ru' }

  spec.platform     = :ios
  spec.platform     = :ios, "13.0"
  spec.static_framework = true
  spec.ios.deployment_target = "13.0"
  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/MosMetro-official/MaaS.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/MaaS/**/*.{swift}"
  spec.exclude_files = "Tests/MaaS/**/*"
  spec.dependency 'MMCoreNetworkAsync'
  spec.dependency 'CoreTableView'
  spec.dependency 'SDWebImage'
  spec.dependency 'OnBoardingModule'
  spec.dependency 'CoreAnalytics'

  spec.resource_bundle = { 'MaaS' => 'Sources/MaaS/**/*.{png,jpeg,jpg,pdf,storyboard,xib,xcassets,otf,ttf}' }

  spec.test_spec 'MaaSTests' do |test_spec|
    test_spec.source_files = "Tests/MaaSTests**/*.{swift}"
    test_spec.dependency 'MMCoreNetworkAsync'
    test_spec.dependency 'CoreTableView'
    test_spec.dependency 'SDWebImage'
    test_spec.dependency 'OnBoardingModule'
    test_spec.dependency 'CoreAnalytics'

  end

end