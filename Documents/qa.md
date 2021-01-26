# 常见问题



### 1. dyld: Library not loaded: @rpath/libswiftCore.dylib

修复方式：Target - Build Settings - Always Embed Swift Libraries - Yes

参照链接：https://stackoverflow.com/questions/26024100/dyld-library-not-loaded-rpath-libswiftcore-dylib/26949219


### 2. HHDoctorSDK image not found

修复方式：Target - General - Frameworks,Libraries,and Embedded Content - HHDoctorSDK.framework 勾选为 ‘Embed & Sign’

如果主工程是纯Object-C的项目，为了适配iOS 12之前的版本，需额外做如下配置

Target - Build Settings - Always Embed Swift Standard Libraries - YES

参照链接：https://help.apple.com/xcode/mac/11.4/index.html?localePath=en.lproj#/itcaec37c2a6



