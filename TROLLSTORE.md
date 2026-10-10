# AirCard for iOS 17.0 / TrollStore

This fork is an experimental TrollStore port of Mak5er/AirCard-iOS, based on
upstream commit `40640c4d827aeab8d798285b57d24fcf6be070d0` (v1.3.2).

## 安装

1. 下载 `AirCard-iOS17-TrollStore.ipa`，用已安装的 TrollStore 打开并安装。
2. 在 Wallet 页面扫描卡片，再选择图片；密码主题默认使用 iOS 17 的
   `TelephonyUI-9` 缓存。
3. 本版本直接访问文件，不需要配对文件或 LocalDevVPN。

最低系统版本和底层 Rust 库均按 iOS 17.0 构建。应用带有
`platform-application`、`com.apple.private.security.no-sandbox` 和
`com.apple.private.security.storage.AppDataContainers` 权限，因此需要
TrollStore 安装。

**本版本尚未在 iOS 17.0 真机验证。** 编译成功不代表 Wallet、密码主题、
PosterBoard 壁纸或 NeoSpring 的全部功能已验证可用。Apple Card 的动态卡面
仍无法替换为普通静态图片。缓存路径、壁纸格式和刷新行为可能因系统版本而不同。

被覆盖的原文件会保存在“文件”App 的 `AirCard-iOS/TrollStoreBackups` 目录下，
按照原来的完整目录结构保存；再次应用主题不会覆盖第一次保留的原文件。
此备份目录需要保留，当前没有应用内一键恢复按钮。

## Build

The GitHub Actions workflow **Build iOS 17 TrollStore IPA** runs on macOS 15
with Xcode 16.4. It checks the direct file writer, rebuilds the Rust device
static library with deployment target 17.0 and the `trollstore` Cargo feature,
regenerates the Xcode project, builds the arm64 app, ad-hoc signs it with the
TrollStore entitlements, and verifies the resulting IPA's plist, Mach-O
minimum OS, and signature. The artifact includes a SHA-256 checksum.

For a local macOS build:

```sh
brew install xcodegen
./build-ios.sh
xcodegen generate
bash build-ipa.sh Release
```

Use the rebuilt library and generated project together: the prebuilt upstream
XCFramework uses the original AirTraffic backend.
