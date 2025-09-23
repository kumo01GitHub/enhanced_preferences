#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint enhanced_preferences.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name              = 'enhanced_preferences'
  s.version           = '0.2.0'
  s.summary           = 'Wraps platform-specific persistent storage for simple data.'
  s.description       = <<-DESC
Wraps platform-specific persistent storage for simple data.
                        DESC
  s.homepage          = 'https://github.com/kumo01GitHub/enhanced_preferences'
  s.license           = { :file => '../LICENSE' }
  s.source            = { :path => '.' }
  s.source_files      = 'enhanced_preferences/Sources/enhanced_preferences/**/*.swift'
  s.resource_bundles  = {'enhanced_preferences_privacy' => ['enhanced_preferences/Sources/enhanced_preferences/PrivacyInfo.xcprivacy']}
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
