# README

```
npx appcenter-cli codepush release-react -a heenqiao1-ut.cn/TestHot -d Staging
npx appcenter-cli login
```

```
先删除 platformMap.json、index*Map.json，确保 xx.config.js 文件都处于项目根目录，确保 common.js index.js index-main.js 文件都已经保存成功
注意在用数字作为 module id 打包时，业务模块入口文件的名称 index1.js 要跟 multibundler 目录中的 ModuleIdConfig.json 文件中的 key 一一对应
npx react-native bundle --platform ios --dev false --entry-file ./common.js --bundle-output ./dist/ios/ios.common.bundle --config ./metro.platform.config.js
npx react-native bundle --platform ios --dev false --entry-file ./index-main.js --bundle-output ./dist/ios/ios.index.main.bundle --config ./metro.buz.config.js
npx react-native bundle --platform ios --dev false --entry-file ./ut-src/index.js --bundle-output ./dist/ios/ios.index.busn1.bundle --config ./metro.buz.config.js
```

```
PLATFORM=iOS npx react-native bundle --platform ios --dev false --entry-file ./common.js --bundle-output ./dist/ios.common.bundle --sourcemap-output ./dist/ios.common.bundle.map --config ./metro.common.config.js

PLATFORM=iOS npx react-native bundle --platform ios --dev false --entry-file ./index.js --bundle-output ./dist/ios.index.busn1.bundle --sourcemap-output ./dist/ios.index.busn2.bundle.map --config ./metro.business.config.js

PLATFORM=Android npx react-native bundle --platform android --dev false --entry-file ./common.js --bundle-output ./dist/android.common.bundle --sourcemap-output ./dist/android.common.bundle.map --config ./metro.common.config.js

PLATFORM=Android npx react-native bundle --platform android --dev false --entry-file ./index.js --bundle-output ./dist/android.index.busn1.bundle --sourcemap-output ./dist/android.index.busn1.bundle.map --config ./metro.business.config.js
```