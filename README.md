# birthday_page

用于承载生日页面能力的 Flutter 插件基础工程。共享 Dart API 与六个平台的注册入口已经搭好，后续可以在共享层实现页面和业务逻辑，并在需要时扩展各端原生能力。

## 支持平台

| 平台 | 实现入口 |
| --- | --- |
| Android | `android/`（Kotlin） |
| iOS | `ios/`（Swift） |
| Web | `lib/birthday_page_web.dart` |
| Windows | `windows/`（C++） |
| macOS | `macos/`（Swift） |
| Linux | `linux/`（C++） |

## 开发

```bash
flutter pub get
flutter test
cd example
flutter run
```

公开 Dart API 从 `lib/birthday_page.dart` 开始；`lib/birthday_page_platform_interface.dart` 定义平台接口，`lib/birthday_page_method_channel.dart` 提供 MethodChannel 默认实现。各平台目录负责注册和原生实现。示例应用位于 `example/`。

目前的 `getPlatformVersion()` 是用于验证六端注册和通信链路的占位 API。正式功能确定后，可从这个接口扩展页面配置、生命周期及平台能力。根目录 `assets/` 中的文件已作为 package assets 声明，应用侧可通过 `packages/birthday_page/assets/...` 引用。

Android 原生包名当前使用生成器默认值 `com.example.birthday_page`；确定发布组织名后，可统一替换 Android 包名与 Gradle namespace。

