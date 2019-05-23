# 视频医生带药 SDK 接入说明


## pod 集成方式

```shell
use_frameworks!
pod 'HHMedicine', :git => "http://code.hh-medic.com/hh_public/HHMedicineSDK.ios.git", :branch => 'develop'
```

## 接入

### 初始化

建议在 Appdelegate 中的 `didFinishLaunchingWithOptions` 方法下初始化 SDK

```
let config = HHSDKOptions(productId: "3000")
config.isDevelopment = isTest
config.isDebug = true
HHMedicine.default.start(option: config)
```

### 其他配置

- 配置 scheme
    
    在 project -> Info -> URL Types 下配置 scheme 为 `hh-medic.com`
    
    
    
- 配置 openUrl