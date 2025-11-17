#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ve_sdk_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 've_sdk_flutter'
  s.version          = '0.33.0'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://www.banuba.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Banuba' => 'support@banuba.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  sdk_version = '1.48.2'

  ENABLE_FACE_AR = ENV['ENABLE_FACE_AR'] == 'true' || ENV['ENABLE_FACE_AR'].nil?

  s.dependency 'BanubaARCloudSDK', sdk_version #optional
  s.dependency 'BanubaVideoEditorSDK', sdk_version
  s.dependency 'BanubaAudioBrowserSDK', sdk_version #optional
  if ENABLE_FACE_AR
      puts "!!! BANUBA FACE AR IS ENABLED !!!"
      s.dependency 'BanubaSDK', sdk_version
  else
    puts "!!! BANUBA FACE AR IS DISABLED !!!"
  end
  s.dependency 'BanubaSDKSimple', sdk_version

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
