# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HHMSDKDemo' do
  use_frameworks!
  pod 'HHDoctorSDK', :git => "git@code.hh-medic.com:hh_public/HHDoctorSDK.ios.git"
end



post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end