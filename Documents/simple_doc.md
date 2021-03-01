

## 和缓SDK对接文档 <简要流程版>



### 一：接入

```
#在 Podfile 文件中加入
use_frameworks!
pod 'HHDoctorSDK', :git => "http://code.hh-medic.com/shijian/HHDoctorSDK.ios.open.git"

#执行
pod install
```



### 二：**初始化**

```
let config = HHSDKOptions(sdkProductId: “xxxx”)
config.isDevelopment = true //是否是测试环境
HHMSDK.default.start(option: **config**)
```



### 三：登录登出

```
//登录
HHMSDK.default.login(userToken: "xxxx") { [weak self] in
  if let aError = $0 {
		print("登录错误: " + aError.localizedDescription)
  } else {
		 print("登录成功")
  }
}

//登出
HHMSDK.default.logout()
```



### 四：跳转首页

```
HHMSDK.default.skipChatHome()
```



### 五：Demo及详细文档：

https://github.com/HHMedic/HHDoctorSDK_demo_iOS