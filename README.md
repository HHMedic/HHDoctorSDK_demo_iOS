# HHDoctorSDK 接入说明

   * [HHDoctorSDK 接入说明](#hhdoctorsdk-接入说明)
      * [1. 概要介绍](#1-概要介绍)
      * [2. 集成方式](#2-集成方式)
         * [2.1. 手动集成](#21-手动集成)
         * [2.2. 自动集成](#22-自动集成)
         * [2.3. 调用规则](#23-调用规则)
      * [3. 初始化](#3-初始化)
      * [4. 登录账户](#4-登录账户)
         * [4.1. 登录](#41-登录)
         * [4.2. 登出](#42-登出)
      * [5. 视频呼叫](#5-视频呼叫)
      * [6. 代理(delegate)(可选)](#6-代理delegate可选)
         * [6.1. 加入](#61-加入)
         * [6.2. 移除](#62-移除)
         
## 1.概要介绍
## 2.集成方式
 HHDoctorSDK 提供两种集成方式：您既可以通过 CocoaPods 自动集成我们的 SDK，也可以通过手动下载 SDK, 然后添加到您的项目中。
我们提供两个下载地址。分别为：

- 官网 SDK [下载入口]()，需要下载完整版 iOS SDK。
- 我们提供了 GitHub 发布仓库 [HHDoctorSDK]()。

由于呼叫视频需要相机相册权限，需要在info.plist中添加对应的权限，否则会导致无法调用。

```
<key>NSPhotoLibraryUsageDescription</key>
<string>应用需要使用相册权限，以便您向医生发送健康资料。</string>
<key>NSCameraUsageDescription</key>
<string>应用需使用相机权限，以便您向医生进行视频咨询。</string>
<key>NSMicrophoneUsageDescription</key>
<string>应用需使用麦克风权限，以便您向医生进行视频咨询。</string>
```

### 2.1.手动集成

1. 根据自己工程需要，下载对应版本的 HHMSDK，得到 NIMSDK.framework ，NIMAVChat.framework，NVS.framework，SecurityKit.framework 和 HHDoctorSDK.framework，以及未链接的全部三方依赖库 [^注1] ，将他们导入工程。
[^注1]: 开发者应根据自身项目，将不冲突的依赖库添加进工程。
2. 添加其他 HHDoctorSDK 依赖库。

    - SystemConfiguration.framework
    - MobileCoreServices.framework
    - AVFoundation.framwork
    - CoreTelephony.framework
    - CoreMedia.framework
    - VideoToolbox.framework
    - AudioToolbox.framework
    - libz
    - libsqlite3.0
    - libc++
3. 在 `Build Settings` -> `Other Linker Flags` 里，添加选项 `-ObjC`[^注2]。
4. 在 `Build Settings` -> `Enable Bitcode 里，设置为 `No`。
5. 如果需要在后台时保持音频通话状态，在 `Capabilities` -> `Background Modes` 里勾选 `audio, airplay, and Picture in Picture`。
[^注2]: 如果使用 pod，可以在 pod 中进行配置。

### 2.2.自动集成
* 在 `Podfile` 文件中加入

```shell
use_frameworks!
pod 'HHDoctorSDK', :git => "git@code.hh-medic.com:hh_public/HHDoctorSDK.ios.git"
```
* 安装 [^注3]

``` shell
pod install
```
[^注3]: 也可以通过 `pod update` 更新，更新缓慢可以添加参数 `--no-repo-update`。

### 2.3.调用规则
所有 HHDoctorSDK 业务均通过 HHMSDK 单例调用

```swift
public class HHMSDK : NSObject {

    public static let `default`: HHDoctorSDK.HHMSDK
}
```

## 3.初始化
在使用 HHDoctorSDK 任何方法之前，都应该首先调用初始化方法。正常业务情况下，初始化方法有仅只应调用一次。

HHSDKOptions 选项参数列表

参数|类型|说明
------|---|--------
isDevelopment|Bool|服务器模式（测试/正式）
isDebug|Bool|调试模式(是否打印日志)
hudManager| HHHUDable|自定义 progressHUD
hudDisTime| Double|hud 自动消失时间

调用示例

```swift
let option = HHSDKOptions(isDebug: true, isDevelop: true)
// let option = HHSDKOptions()
// option.isDevelopment = true
// option.isDebug = true
// option.hudDisTime = 2
HHMSDK.default.start(option: option)
```

## 4. 登录账户
在对医生视频呼叫之前，需要先登录账号信息。账号的 uuid 由和缓提供。
### 4.1. 登录

* 原型

```swift
public class HHMSDK : NSObject {

    /// 登录账号
    ///
    /// - Parameters:
    ///   - uuid: 用户的 唯一标志符
    ///   - completion: 完成回调
    public func login(uuid: Int, completion: @escaping HHMedicSDK.HHLoginHandler)
}
```

* 调用示例

```swift
// 登录
HHMSDK.default.login(uuid: 100001531) { (error) in
    if let aError = error {
        print("登录错误: " + aError.localizedDescription)
    }
}
```
error 为登录错误信息，成功则为 nil。

### 4.2. 登出
应用层登出/注销/切换自己的账号时需要调用 HHMSDK 的登出操作，该操作会通知和缓服务器进行 APNs 推送信息的解绑操作，避免用户已登出但推送依然发送到当前设备的情况发生。

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

## 5. 视频呼叫
根据实际场景的不同，可以进行成人、儿童方向的向医生咨询。

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

HHCallType 枚举列表

值 | 说明
--------- | -------------
child | 儿童
adult | 成人

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




