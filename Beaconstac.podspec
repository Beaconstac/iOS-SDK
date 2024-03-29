Pod::Spec.new do |s|
  s.name         = 'Beaconstac'
  s.version      = '3.2.12'
  s.swift_version = '5.0'
  s.summary      = 'iOS library for iBeacon devices'

  s.homepage     = 'https://github.com/Beaconstac/iOS-SDK'
  s.authors      = { 'MobStac Inc.' => 'support@beaconstac.com' }

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.source       = { :git => 'https://github.com/Beaconstac/iOS-SDK.git', :tag => "#{s.version}" }

  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.vendored_frameworks = 'Beaconstac/Beaconstac.framework'

  s.dependency 'EddystoneScanner'

  s.frameworks   = 'CoreData', 'SystemConfiguration', 'CoreBluetooth', 'CoreLocation', 'UserNotifications', 'SafariServices'

  s.requires_arc = true
  s.ios.deployment_target = "11.0"
end
