import Foundation
import SwiftUI

enum TrollStoreAccess {
    static var enabled: Bool {
        #if TROLLSTORE
        return true
        #else
        return false
        #endif
    }

    static func posterBoardContainer() throws -> String {
        let manager = FileManager.default
        for root in ["/var/mobile/Containers/Data/Application", "/var/mobile/Containers/Data/System", "/var/mobile/Containers/Shared/AppGroup"] {
            guard let folders = try? manager.contentsOfDirectory(atPath: root) else { continue }
            for folder in folders {
                let container = URL(fileURLWithPath: root).appendingPathComponent(folder)
                let metadata = container.appendingPathComponent(".com.apple.mobile_container_manager.metadata.plist")
                guard let data = try? Data(contentsOf: metadata),
                      let dictionary = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
                      let identifier = dictionary["MCMMetadataIdentifier"] as? String,
                      identifier == "com.apple.PosterBoard" else { continue }
                return container.path
            }
        }
        throw NSError(domain: "TrollStoreAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法读取 PosterBoard 容器。请通过巨魔安装此版本，并解锁 iPhone。"])
    }
}

struct TrollStoreSetupView: View {
    @State private var showCredits = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("AirCard · 巨魔汉化版", systemImage: "creditcard.circle.fill")
                        .font(.title2.bold())
                    Text("iOS 17.0 汉化版 · v1.3.2").foregroundStyle(.secondary)
                    Text("钱包卡面和密码主题通过直接访问文件应用，无需配对文件或 LocalDevVPN。")
                }
                Section("开始使用") {
                    Text("使用巨魔安装此 IPA，然后在“钱包卡片”中扫描卡片，或创建密码主题。")
                    Text("iOS 17 的密码键盘缓存默认使用 TelephonyUI-9。")
                }
                Section("兼容性") {
                    Text("这是实验适配版本，钱包卡面、密码主题和壁纸功能仍需在你的设备上测试。")
                }
                Section("原文件备份") {
                    Text("本版本覆盖的原文件会备份到“文件”App 中的 AirCard-iOS › TrollStoreBackups 目录。")
                }
            }
            .navigationTitle("访问权限")
            .toolbar { Button("关于与致谢") { showCredits = true } }
            .sheet(isPresented: $showCredits) { CreditsSheet() }
        }
    }
}
