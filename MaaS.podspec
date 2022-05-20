#
#  Be sure to run `pod spec lint MaaS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MaaS"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of MaaS."

  spec.description  = "MaaS"

  spec.homepage     = "https://github.com/MosMetro-official/MaaS"

  spec.license      = "MIT"

  spec.author           = { 'vplatonov' => 'slava.p12@yandex.ru' }

  spec.platform     = :ios
  spec.platform     = :ios, "13.0"
  spec.static_framework = true
  spec.ios.deployment_target = "13.0"
  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/MosMetro-official/MaaS.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/MaaS/**/*.{swift}"
  spec.exclude_files = "Tests/MaaS/**/*"
  spec.dependency 'MMCoreNetworkCallbacks'
  spec.dependency 'CoreTableView'

  spec.resource_bundle = { 'MaaS' => 'Sources/MaaS/**/*.{png,jpeg,jpg,pdf,storyboard,xib,xcassets,otf,ttf}' }

end