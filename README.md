# README

```
npx appcenter-cli codepush release-react -a heenqiao1-ut.cn/TestHot -d Staging
npx appcenter-cli login
```
-------------------------
## 分包说明

目前该 Demo 的路由架构方案是：
  
  启动时先加载 common.jsbundle，然后初始化第一个页面并且加载 index.main.jsbundle，从这个页面进入其他的业务页面，进入时再加载业务bundle。
  common.jsbundle + MainVC(main.jsbundle) + VC1(busn1.jsbundle)/VC2(busn2.jsbundle)/VC3(busn3.jsbundle)

  iOS端：目前已实现上述的路由架构方案，能加载基础包->主业务包->子业务包

  Android端：目前只实现了加载基础包->主业务包，未实现子业务包busn1的加载和页面跳转

项目目录和文件结构：

1. ut-src/busn1: 业务包目录，其中的 index.js 是业务包的打包入口文件
2. ut-src/main: 首页/主业务包目录，其中的 index.js 是首页业务包的打包入口文件，用于启动时加载完基础包后就加载显示的。其中通过 CustomModule 接口调用原生的代码来加载子业务包和跳转页面。
3. common.js: 基础包打包入口文件
4. multibundler: 该目录是 smallnew 分包方案要用到的

目前优先使用hash字符串作为moduleId的分包方案，该方案实现简单，从而也不容易出问题。
  * metro.common.config.js：是基础包的打包配置文件，会记录打进基础包的模块路径到一个第三方记录文件，用于后面打业务包时进行判断
  * metro.business.config.js：是业务包的打包配置文件，会对自己的业务代码的模块每次打包生成不同的moduleId，用于在加载时新版本的业务包能覆盖旧的业务包

使用下面的命令分包基础包和业务包，其中需要按照不同的系统进行分包。sourcemap-output 选项是用于生成代码包的map文件上传到sentry，在发生问题时能查到哪行代码出问题。

```zsh
//iOS 基础包
PLATFORM=iOS npx react-native bundle --platform ios --dev false --entry-file ./common.js --bundle-output ./dist/ios.common.jsbundle --sourcemap-output ./dist/ios.common.jsbundle.map --config ./metro.common.config.js

//iOS 主业务包
PLATFORM=iOS npx react-native bundle --platform ios --dev false --entry-file ./ut-src/main/index.js --bundle-output ./dist/ios.index.main.jsbundle --sourcemap-output ./dist/ios.index.main.jsbundle.map --config ./metro.business.config.js

//iOS 业务包
PLATFORM=iOS npx react-native bundle --platform ios --dev false --entry-file ./ut-src/busn1/index.js --bundle-output ./dist/ios.index.busn1.jsbundle --sourcemap-output ./dist/ios.index.busn1.jsbundle.map --config ./metro.business.config.js

//Android 基础包
PLATFORM=Android npx react-native bundle --platform android --dev false --entry-file ./common.js --bundle-output ./dist/android.common.bundle --sourcemap-output ./dist/android.common.bundle.map --config ./metro.common.config.js

//Android 业务包
PLATFORM=Android npx react-native bundle --platform android --dev false --entry-file ./ut-src/busn1/index.js --bundle-output ./dist/android.index.busn1.bundle --sourcemap-output ./dist/android.index.busn1.bundle.map --config ./metro.business.config.js
```

另一种方案是使用 [react-native-multibundler](https://github.com/smallnew/react-native-multibundler) 的分包方案，支持数字和字符串两种moduleId的分包方案，而且支持分包后debug，相对上面的方案更完善，但是实现较复杂，需要谨慎考虑，特别是分包后发布应用后，需要进行热更新或者发布下一个版本的应用时该分包方案可能会有的问题。

```
先删除 platformMap.json、index*Map.json，确保 xx.config.js 文件都处于项目根目录，确保 common.js index.js index-main.js 文件都已经保存成功
注意在用数字作为 module id 打包时，业务模块入口文件的名称 index1.js 要跟 multibundler 目录中的 ModuleIdConfig.json 文件中的 key 一一对应，因为是以入口文件的名称来区分不同的分配moduleId的数字区间。

//iOS 基础包
npx react-native bundle --platform ios --dev false --entry-file ./common.js --bundle-output ./dist/ios/ios.common.jsbundle --config ./metro.platform.config.js

//iOS 主业务包
npx react-native bundle --platform ios --dev false --entry-file ./ut-src/main/index.js --bundle-output ./dist/ios/ios.index.main.jsbundle --config ./metro.buz.config.js

//iOS 业务包
npx react-native bundle --platform ios --dev false --entry-file ./ut-src/busn1/index.js --bundle-output ./dist/ios/ios.index.busn1.jsbundle --config ./metro.buz.config.js
```

--------------------------
iOS 端结构说明：

* NumIndexBundle：存放用 multibundler 的数字moduleId方案分包出来的 bundle，包括 num.ios.index.common.bundle、num.ios.index.main.bundle、num.ios.index.busn1.bundle 共 3个 bundle
* StringIndexBundle：以第一种hash字符串作为moduleId的方案分包出来的 bundle，包括 common.bundle、index.busn1.bundle、index.busn2.bundle、index.main.bundle，其中 busn2 的bundle是对 busn1 的代码进行部分改动后重新打包的，用来测试在进入 busn1 页面后重新加载改动后的新业务包 busn2 是否会立刻刷新页面的
* SmallNewMultiBundle：smallnew 的 multibundler 方案的 iOS 端的原生加载代码，但是有缺陷，只能是以原生应用启动后再加载业务包
* UTReactMultiBundle：我根据[React Native（二）：分包机制与动态下发](https://juejin.cn/post/6844903922205736973)中的 iOS 原生加载的代码修改后的实现，融合上面 multibundler 的部分代码
* AppDelegate：展示 UTReactMultiBundle 的使用用例

Andoird 端结构说明：目前Android端的原生加载代码是根据 smallnew  的代码修改而来的

* src/main/assets: 存放分包后的 bundle，目前只有 common.bundle、busn1.bundle，因为 Android 端的原生目前只支持启动加载基础包和主业务包，未实现子业务包加载和页面跳转
* src/main/java/com/awesometsproject/MainActivity.java: 在这个文件返回业务包的包名bundleName和业务包入口页面名称 componentName
* src/main/java/com/awesometsproject/MainApplicaiton.java: 在这个文件返回基础包的包名或者路径

