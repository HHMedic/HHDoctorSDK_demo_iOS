platform :ios, '9.0'

use_frameworks!

# 带药 SDK demo
target 'HHMedicineDemo' do
  pod 'SnapKit'
  pod 'SVProgressHUD'
  
  pod 'AlipaySDK-iOS'
  
  pod 'HHMedicine', :git => "https://code.hh-medic.com/hh_public/HHMedicineSDK.ios.git", :branch => 'develop'
end

# 和缓视频医生 SDK demo
target 'HHMSDKDemo' do
  pod 'SVProgressHUD'
  pod 'SnapKit'
  pod 'HHDoctorSDK', :git => "http://code.hh-medic.com/shijian/HHDoctorSDK.ios.open.git"
  
  #如果使用XCode 11.4.1及以上版本请使用以下版本引用
  #pod 'HHDoctorSDK', :git => "git@code.hh-medic.com:shijian/HHDoctorSDK.ios.open.git",:branch => 'feature/swift5.2'

end
