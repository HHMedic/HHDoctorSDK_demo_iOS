# HHDoctorSDK 接入说明
   * [HHDoctorSDK 接入说明](#hhdoctorsdk-接入说明)
      * [0. 更新日志](#0-更新日志)
      * [1. 集成方式](#1-集成方式)
         * [1.1. 自动集成](#12-自动集成推荐)
         * [1.2. 调用规则](#13-调用规则)
      * [2. 初始化](#2-初始化)
      * [3. 登录账户](#3-登录账户)
         * [3.1. 登录](#31-登录)
         * [3.2. 登出](#32-登出)
      * [4. 视频呼叫](#4-视频呼叫)
         * [4.1 呼叫](#41-呼叫)
         * [4.2 使用指定账户发起通话](#42-使用指定账户发起通话)
         * [4.3 多人通话](#43-多人呼叫)
      * [5. 病历接口](#5-病历接口)
      * [6. 代理(delegate)(可选)](#5-代理delegate可选)
         * [6.1. 加入](#51-加入)
         * [6.2. 移除](#52-移除)
      
      * [7. 其他配置](#6-其他配置)
         * [7.1. APNs](#61-apns)
         * [7.2. Background Modes](#62-background-modes)
      * [问题说明](#问题说明)
         * [支付宝 SDK 冲突](#支付宝-sdk-冲突)
         * [userToken 说明](#userToken-说明)
         * [demo 运行说明](#demo-运行说明)
      * [送药SDK](#送药SDK)
      
     
      
> HHDoctorSDK 的 demo 请切换到 Scheme 为 `HHMSDKDemo` 下编译。
      
##  0. 更新日志

> 2.6.2 (2020-07-21)

    1. 增加多人呼叫支持


> 2.6.0 (2020-03-01)

    1. 内部逻辑优化

> 2.4.4.2 (2019-12-31)

    1. 新增 使用指定账户发起通话 ([4.2](#42-使用指定账户发起通话))
    * demo 请查看HHMSDKDemo/NormalCallVC.swift


> 2.4.4（2019-11-25）

    1. 优化排队功能(重要)
    2. 修复已知问题


> 2.1.0（2019-05-30）

    1. 修复已知问题
    


> 2.0.6

    1. 仅支持 Swift5
    2. 增加病历列表和病历详情接口
    3. 删除UTDID.framework
    4. iOS 最低版本支持到iOS 8.0

> 2.0.2

     1. 适配 Xcode 10, swift4.2
 

## 1. 集成方式

说明: 接入 HHDoctorSDK 大概会使 ipa 包增加 15M.
 HHDoctorSDK 提供两种集成方式：您既可以通过 CocoaPods 自动集成我们的 SDK，也可以通过手动下载 SDK, 然后添加到您的项目中。
我们提供的下载地址：

 集成demo地址: [HHDoctorSDK_demo_iOS](https://github.com/HHMedic/HHDoctorSDK_demo_iOS)

由于呼叫视频需要相机相册权限，需要在info.plist中添加对应的权限，否则会导致无法调用。

```
<key>NSPhotoLibraryUsageDescription</key>
<string>应用需要使用相册权限，以便您向医生发送健康资料。</string>
<key>NSCameraUsageDescription</key>
<string>应用需使用相机权限，以便您向医生进行视频咨询。</string>
<key>NSMicrophoneUsageDescription</key>
<string>应用需使用麦克风权限，以便您向医生进行视频咨询。</string>
```

### 1.1. 自动集成
* 在 `Podfile` 文件中加入

```shell
use_frameworks!
pod 'HHDoctorSDK', :git => "http://code.hh-medic.com/shijian/HHDoctorSDK.ios.open.git"
```
* 安装

``` shell
pod install
```

### 1.2. 调用规则
所有 HHDoctorSDK 业务均通过 HHMSDK 单例调用

```swift
public class HHMSDK : NSObject {

    public static let `default`: HHDoctorSDK.HHMSDK
}
```

## 2. 初始化
在使用 HHDoctorSDK 任何方法之前，都应该首先调用初始化方法。正常业务情况下，初始化方法有仅只应调用一次。

HHSDKOptions 选项参数列表

参数|类型|说明
------|---|--------
sdkProductId|String|视频医生提供方分配的产品ID（必填）
isDevelopment|Bool|服务器模式（测试/正式）
isDebug|Bool|调试模式(是否打印日志)
APNs|String |推送证书名（由视频医生提供方生成）
hudManager| HHHUDable|自定义 progressHUD
hudDisTime| Double|hud 自动消失时间

调用示例

```swift
let option = HHSDKOptions(isDebug: true, isDevelop: true)
option.cerName = "2cDevTest"
// let option = HHSDKOptions()
// option.isDevelopment = true
// option.isDebug = true
// option.hudDisTime = 2
HHMSDK.default.start(option: option)
```


## 3. 登录账户
在对医生视频呼叫之前，需要先登录账号信息。账号的 uuid 由视频医生提供方提供。
### 3.1. 登录

* 原型

```swift
public class HHMSDK : NSObject {

    /// 登录账户
    ///
    /// - Parameters:
    ///   - userToken: 用户的唯一标志
    ///   - completion: 完成的回调
    @objc  public func login(userToken: String, completion: @escaping HHLoginHandler) {
}
```

* 调用示例

```swift
// 登录
HHMSDK.default.login(userToken: "token") { [weak self] in
    if let aError = $0 {
        print("登录错误: " + aError.localizedDescription)
    } else {
        print("登录成功")
    }
}
```
error 为登录错误信息，成功则为 nil。

### 3.2. 登出
应用层登出/注销/切换自己的账号时需要调用 HHMSDK 的登出操作，该操作会通知视频医生提供方服务器进行 APNs 推送信息的解绑操作，避免用户已登出但推送依然发送到当前设备的情况发生。

* 原型

```swift
public class HHMSDK : NSObject {

    /// 登出
    public func logout()
}
```

* 调用示例

```swift
// 登出
HHMSDK.default.logout()
```

## 4. 视频呼叫
根据实际场景的不同，可以进行成人、儿童方向的向医生咨询。

### 4.1 呼叫

* 原型

```swift
public class HHMSDK : NSObject {

    /// 主叫发起通话
    ///
    /// - Parameter type: 呼叫类型
    public func startCall(_ type: HHMedicSDK.HHCallType)
}
```

* 调用示例

```swift
// 咨询儿童问题
HHMSDK.default.startCall(.child)

// 咨询成人问题
HHMSDK.default.startCall(.adult)
```

### 4.2 使用指定账户发起通话

```Swift
/// 使用指定账户发起通话
/// - Parameter type: 呼叫类型
/// - Parameter from: 当前呼叫使用的用户标识符(token)
/// - Parameter delegate: 呼叫代理
@objc public func startCallBy(_ from: String, type: HHDoctorSDK.HHCallType, delegate: HHDoctorSDK.HHCallDelegate? = nil)
```
  
* 调用示例(请和商务确认好后再调用此接口)
  
```
HHMSDK.default.startCallBy("token", type: .child)
```

HHCallType 枚举列表

值 | 说明
--------- | -------------
child | 儿童
adult | 成人


### 4.3 多人呼叫


```Swift
/// 主动发起多人通话
///
/// - Parameters:
///   - type: 呼叫类型
///   - callee: 被呼叫人的信息
@objc public func startTeamCall(_ type: HHDoctorSDK.HHCallType, callee: HHDoctorSDK.HHCallerInfo)
```

* 调用示例
  
```
let callee = HHCallerInfo()
callee.name = "测试用户"
callee.photourl = "https://image.hh-medic.com/icon/head_logo1.png"
callee.userToken = userToken

HHMSDK.default.startTeamCall(.adult, callee: callee)
```



## 5. 病历接口

获取所有成员的病历列表

```
/// 获取所有成员的病历列表(推荐使用)
    ///
    /// - Parameter userToken: 主账户的唯一标志
    /// - Returns: url
    @objc public func getAllMedics(userToken: String) -> String {
    }
```

病历详情

```
/// 获取病历详情
///
/// - Parameters:
///   - userToken: 当前人的唯一标志
///   - medicId: 病历id
/// - Returns: url
@objc public func getMedicDetail(userToken: String, medicId: String) -> String {
    }
```

## 6. 代理(delegate)(可选)
代理主要用于视频过程中的状态反馈。如果不需要状态反馈，可以不考虑该代理。
所有的代理方法都是可选的，可以根据自己的实际需要实现不同的代理方法。

* 原型

```swift
/// 视频管理器代理
public protocol HHMVideoDelegate : NSObjectProtocol {

    /// 主动视频时的呼叫状态变化
    ///
    /// - Parameter state: 当前呼叫状态
    public func callStateChange(_ state: HHMedicSDK.HHMCallingState)

    /// 通话已接通
    public func callDidEstablish()

    /// 呼叫失败
    public func onFail(error: Error)

    public func onCancel()

    /// 通话已结束 (接通之后才有结束)
    public func callDidFinish()

    /// 转呼医生
    public func onExtensionDoctor()

    /// 接收到呼叫(被呼叫方)
    ///
    /// - Parameters:
    ///   - callID: 呼叫的 id
    ///   - from: 呼叫人 id
    public func onReceive(_ callID: String, from: String)

    /// 收到视频呼入时的操作（被呼叫方）
    ///
    /// - Parameter accept: 接受或者拒接
    public func onResponse(_ accept: Bool)

    /// 缺少必要权限
    ///
    /// - Parameter type: 缺少的权限类型
    public func onLeakPermission(_ type: HHMedicSDK.PermissionType)
}
```

### 6.1. 加入
代理支持同时设置多个。

```swift
HHMSDK.default.add(delegate: self)
```

### 6.2. 移除

```swift
HHMSDK.default.remove(delegate: self)
```


## 7. 其他配置

### 7.1. APNs

在 appDelegate 中向 SDK 传入 deviceToken 即可。

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    HHMSDK.default.updateAPNS(token: deviceToken)
}
```

*注意：需要上传 APNs 的 p12 文件，请联系我们上传。*

### 7.2. Background Modes

为了支持用户压后台后音视频的正常使用，需要设置 Background Modes。具体设置如下：

```
xxx target -> Capabilities -> Background Modes -> 勾选 Audio，Airplay and Picture in Picture
```




## 问题说明

### 支付宝 SDK 冲突
若出现UTDID冲突错误,请切换支付宝 SDK 到无UTDID版本.
[官方说明](https://docs.open.alipay.com/54/104509/)

### userToken 说明
userToken由服务端对接生成，每个用户注册时都会返回uuid和对应的userToken，如果服务端之前没有记录这个字段，可以联系我们服务端同事帮忙重新生成。

### demo 运行说明

1. 运行前请先执行'pod update', 时间可能稍长，请耐心等待
2. 请使用最新的 XCode 执行 'HHMSDKDemo.xcworkspace'
3. 请选择`真机`进行调试, SDK 不支持模拟器运行
4. 如果报错关于证书相关，请在 Sign & Capabilities中切换到自己的开发者账号，并修改 bundleid

## 送药SDK
[需要送药功能请查看此文档](./Documents/medicine.md)
