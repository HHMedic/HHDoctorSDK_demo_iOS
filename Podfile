# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'HHMSDKDemo' do
  use_frameworks!
  pod 'SnapKit'
  pod 'HHDoctorSDK', :git => "http://code.hh-medic.com/hh_public/HHDoctorSDK.ios.git"
end



post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['SWIFT_VERSION'] = '4.2'

    end
  end
end
