# Birthday Page

`birthday_page` 是一个跨平台 Flutter 生日庆祝页面插件，包含蛋糕、蜡烛、火焰、烟雾和礼花动画。在 Android 上支持通过麦克风识别吹气动作来吹灭蜡烛。

庆祝页面支持 Android、iOS、Web、Windows、macOS 和 Linux；麦克风吹气识别目前正式支持 Android，其他平台可使用手动吹灭功能。Android 音频仅在内存中分析，不会保存或上传录音。

## 安装

在应用的 `pubspec.yaml` 中添加依赖。项目内本地接入可以使用路径依赖：

```yaml
dependencies:
  birthday_page:
    path: ../birthday_page
```

然后获取依赖：

```shell
flutter pub get
```

## 快速开始

```dart
import 'package:birthday_page/birthday_page.dart';

BirthdayCelebrationPage(
  name: '伟伟',
  onCelebrated: () {
    // 每次成功吹灭蜡烛后调用一次。
  },
  onSkip: () {
    // 用户点击“跳过”后调用，可在这里执行页面跳转。
  },
)
```

运行 `example` 示例：

```shell
cd example
flutter run
```

在 Android 上点击“开始庆祝”并授予麦克风权限，先保持安静约 600 毫秒完成环境声音校准，然后朝麦克风稳定吹气约 500 毫秒。未授权麦克风或使用其他平台时，用户仍可点击手动吹灭按钮完成庆祝流程。

## 组件 API

### BirthdayCelebrationPage

生日庆祝页面的主要公开组件。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `Key?` | `null` | Flutter Widget 标识。 |
| `name` | `String` | `'伟伟'` | 寿星姓名，会替换祝福文案中的 `{name}`。 |
| `texts` | `BirthdayCelebrationTexts` | `BirthdayCelebrationTexts.zhHans` | 页面全部可见文案。 |
| `fontFamily` | `String?` | `null` | 整页普通文字的字体名称；未设置时继承宿主应用主题。 |
| `birthdayFontFamily` | `String?` | `null` | 大型生日标题的字体名称；依次回退到 `fontFamily` 和 Georgia。 |
| `onCelebrated` | `VoidCallback?` | `null` | 蜡烛成功熄灭后调用，每次庆祝流程只调用一次。 |
| `onSkip` | `VoidCallback?` | `null` | 点击跳过按钮后调用；未传入时不显示跳过按钮。 |

## 多语言文案

插件内置简体中文和英文：

```dart
const BirthdayCelebrationPage(
  texts: BirthdayCelebrationTexts.zhHans,
)
```

```dart
const BirthdayCelebrationPage(
  texts: BirthdayCelebrationTexts.en,
)
```

可以根据宿主应用当前语言自动选择。中文语言环境使用简体中文，其他语言环境默认使用英文：

```dart
final texts = BirthdayCelebrationTexts.forLocale(
  Localizations.localeOf(context),
);

return BirthdayCelebrationPage(
  name: 'Alex',
  texts: texts,
);
```

### 自定义文案

使用 `copyWith` 覆盖部分文案：

```dart
BirthdayCelebrationPage(
  name: 'Alex',
  texts: BirthdayCelebrationTexts.zhHans.copyWith(
    startButton: '开始许愿',
    birthdayGreeting: '{name}，祝你生日快乐！',
  ),
)
```

也可以创建完整的 `BirthdayCelebrationTexts` 实例，以支持其他语言或品牌文案。

### BirthdayCelebrationTexts 字段

| 字段 | 使用位置 |
| --- | --- |
| `happyHeading` | 页面顶部小标题。 |
| `birthdayTitle` | 页面顶部大型生日标题。 |
| `wishMessage` | 标题下方的祝福说明。 |
| `skipButton` | 跳过按钮。 |
| `initialHint` | 页面初始提示。 |
| `openingMicrophoneHint` | 正在启动麦克风时的提示。 |
| `calibratingHint` | 正在校准环境声音时的提示。 |
| `blowHint` | 校准完成后的吹气提示。 |
| `microphoneUnavailableHint` | 麦克风不可用或权限被拒绝时的提示。 |
| `timeoutHint` | 监听超过 30 秒后的提示。 |
| `resumeHint` | 应用从后台返回后的提示。 |
| `pausedHint` | 用户暂停监听后的提示。 |
| `extinguishingHint` | 火焰正在熄灭时的提示。 |
| `birthdayGreeting` | 蜡烛熄灭后的祝福，支持 `{name}` 占位符。 |
| `startButton` | 开始监听按钮。 |
| `listeningButton` | 正在监听时的按钮。 |
| `retryButton` | 庆祝完成后的再次许愿按钮。 |
| `manualExtinguishButton` | 手动吹灭蜡烛按钮。 |
| `completedMessage` | 庆祝完成后的底部文案。 |

`birthdayGreeting` 中的 `{name}` 会被 `BirthdayCelebrationPage.name` 替换。如果不需要显示姓名，可以省略该占位符。

## 自定义字体

字体由宿主 Flutter 应用注册。例如：

```yaml
flutter:
  fonts:
    - family: MySans
      fonts:
        - asset: assets/fonts/MySans-Regular.ttf
    - family: MyHandwritingFont
      fonts:
        - asset: assets/fonts/MyHandwritingFont.ttf
```

然后将字体名称传给页面：

```dart
BirthdayCelebrationPage(
  fontFamily: 'MySans',
  birthdayFontFamily: 'MyHandwritingFont',
)
```

只设置 `fontFamily` 时，所有文案（包括大型生日标题）都会使用该字体。单独设置 `birthdayFontFamily` 可以让大型标题使用不同的展示字体。

## 平台配置

### Android

插件会自动合并麦克风权限：

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

当前最低支持 Android API 24。

### iOS、macOS、Web、Windows 和 Linux

这些平台目前支持庆祝页面和手动吹灭流程，但麦克风吹气识别尚未列入正式支持范围。

## 吹气识别说明

Android 端通过 `record` 读取 16 kHz、单声道 PCM16 音频流。检测器会根据环境声音中位数建立基线，并综合音量阈值、持续时间、过零率和音量稳定性识别吹气。

吹气识别属于启发式检测。风扇、无声辅音或不同设备的麦克风降噪处理可能影响结果，发布前应在目标真机上验证并调整参数。

监听会在以下情况自动停止：

- 应用进入后台。
- 页面销毁。
- 蜡烛成功熄灭。
- 音频流发生错误。
- 连续监听达到 30 秒。

## 动画时长

- 火焰熄灭动画：750 毫秒。
- 烟雾动画：约 2.2 秒。
- 礼花动画：火焰熄灭 300 毫秒后开始。

## 资源

插件包含已获得版权许可的蛋糕、蜡烛、火焰、烟雾和背景礼花图片，资源通过 package asset 方式加载，宿主应用无需重复声明。

## 许可证

项目采用 [MIT License](LICENSE)。项目所含视觉素材已获得版权许可，可随插件分发。

## 验证

```shell
flutter analyze
flutter test
cd example
flutter test
```

当前测试覆盖吹气检测、任意音频分块、短促噪声过滤、手动吹灭流程、小屏幕布局、多语言文案和自定义字体。实际麦克风识别效果仍需通过真机测试确认。
