# 视频医生带药 SDK 接入说明

带药 SDK 的demo请切换到 Scheme 为 `HHMedicineDemo` 下编译。

## pod 集成方式

```shell
use_frameworks!
pod 'HHMedicine', :git => "http://code.hh-medic.com/hh_public/HHMedicineSDK.ios.git", :branch => 'develop'
```

## 接入

### 初始化

建议在 AppDelegate 中的 `didFinishLaunchingWithOptions` 方法下初始化 SDK

```
let config = HHSDKOptions(productId: "3000")
config.isDevelopment = isTest
config.isDebug = true
HHMedicine.default.start(option: config)
```

### 其他配置

- 配置 URL Types
    
    在 project -> Info -> URL Types 下配置 scheme 为 `hh-medic.com`
    
    ![./URLScheme.png]()
    
- 配置 openUrl

    > 注意：如果接入支付宝/微信 SDK, 务必在 `openurl` 方法中调用相关方法

    在 `AppDelegate` 中的 `func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool` 中进行配置
    
    ```
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return HHMedicine.default.handleOpen(url)
    }
    ```
    

## 注意事项

### 支付宝相关
若接入方没有接入支付宝的 SDK，不会影响订单的支付，但是支付完成后无法回跳到 App，请知悉。
对于接入了支付宝 SDK 的用户，为了完成整个支付流程，请实现 `HHPayMedicable` 代理方法，并在 `AppDelegate` 中的 `openurl` 方法中进行支付宝相关操作

```Swift
/// 实现代理方法
extension ViewController: HHPayMedicable {
    func payInterceptor(_ url: String, scheme: String, callback: @escaping (([AnyHashable : Any]?) -> Void)) -> Bool {
        return AlipaySDK.defaultService()?.payInterceptor(withUrl: url, fromScheme: scheme, callback: callback) ?? false
    }
}

/// openurl
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if handleAliUrl(url) { return true }
    return HHMedicine.default.handleOpen(url)
}
    
func handleAliUrl(_ url: URL) -> Bool {
    if url.host == "safepay" {
        AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
        return true
    }
    return false
}
```

### 支付完成后无法回跳到 App
> 请检查是否设置了 URL Types
> 请检查是否在 Appdelegate 中的 `openurl` 方法中是否调用了相关方法