# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

  use_frameworks!

target 'HHMSDKDemo' do
  pod 'SnapKit'

  pod 'HHDoctorSDK', :git => "http://code.hh-medic.com/hh_public/HHDoctorSDK.ios.git", :branch => 'no/utdid'

end



post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['SWIFT_VERSION'] = '4.2'

    end
  end
end
