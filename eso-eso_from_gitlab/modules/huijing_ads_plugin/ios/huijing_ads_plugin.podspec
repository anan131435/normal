#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint huijing_ads_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'huijing_ads_plugin'
  s.version          = '2.0.1'
  s.summary          = 'huijing ads plugin'
  s.description      = <<-DESC
huijing ads plugin
                       DESC
  s.homepage         = 'http://www.huijingwangluo.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Huijing' => 'hub@huijing.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.dependency 'ToBid-iOS', '3.5.0'
  s.dependency 'ToBid-iOS/AdScopeAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/TouTiaoAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/KSAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/MSAdAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/MintegralAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/GDTAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/CSJMediationAdapter', '3.5.0'
  s.dependency 'ToBid-iOS/BaiduAdapter', '3.5.0'
  s.dependency 'HjOctopusAdapter'
  
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
