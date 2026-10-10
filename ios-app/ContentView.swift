import SwiftUI
import UIKit
import PhotosUI
import UniformTypeIdentifiers

// MARK: - Shared helpers

func logLineColor(_ line: String) -> Color {
    if line.contains("✅") || line.contains("🎉") { return .green }
    if line.contains("❌") { return .red }
    if line.contains("⚠️") { return .orange }
    return .secondary
}

// MARK: - Share Sheet for Exporting .passthm

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Crypto Donation Row

struct CryptoDonationRow: View {
    let title: String
    let address: String
    let icon: String
    let iconColor: Color

    @State private var isCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(.subheadline.bold())
                Text(title)
                    .font(.subheadline.bold())
                Spacer()
                Button {
                    UIPasteboard.general.string = address
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isCopied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isCopied = false
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc.fill")
                        Text(isCopied ? "已复制！" : "复制")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(isCopied ? .green : .blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(isCopied ? Color.green.opacity(0.12) : Color.blue.opacity(0.12))
                    .clipShape(Capsule())
                }
            }

            Text(address)
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .textSelection(.enabled)
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Donate View

struct DonateView: View {
    var isPopup: Bool = false
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            // Creator Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Maksym Reva")
                                .font(.headline.bold())
                            Text("🇺🇦")
                                .font(.subheadline)
                        }
                        Text("@mak5er · 主创与核心开发者")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                // Social Links (Twitter & GitHub)
                HStack(spacing: 10) {
                    Link(destination: URL(string: "https://x.com/mak5er")!) {
                        HStack(spacing: 5) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Twitter / X")
                        }
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.12))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Link(destination: URL(string: "https://github.com/mak5er")!) {
                        HStack(spacing: 5) {
                            Image(systemName: "link")
                            Text("GitHub")
                        }
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primary.opacity(0.08))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Payment Methods
            VStack(alignment: .leading, spacing: 10) {
                Text("捐赠与支持")
                    .font(.caption.bold().uppercaseSmallCaps())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                // PayPal Button
                Link(destination: URL(string: "https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y")!) {
                    HStack(spacing: 10) {
                        Image(systemName: "creditcard.fill")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("通过 PayPal 捐赠")
                                .font(.subheadline.bold())
                            Text("收款人：Maksym Reva")
                                .font(.caption2)
                                .opacity(0.85)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right.square.fill")
                            .font(.subheadline)
                    }
                    .padding(14)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color(red: 0.05, green: 0.35, blue: 0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // TON
                CryptoDonationRow(
                    title: "💎 TON (The Open Network)",
                    address: "UQBm9KPhtMw-XVVjirUoa09wzrlyWsbeZhKfefl1Uw-qNZ-r",
                    icon: "diamond.fill",
                    iconColor: .cyan
                )

                // USDT TRC20
                CryptoDonationRow(
                    title: "💵 USDT (TRC20)",
                    address: "TDkDMCyjYxgvkWUnQiF5Erk2RyPQMT6G1n",
                    icon: "dollarsign.circle.fill",
                    iconColor: .green
                )

                // BEP20
                CryptoDonationRow(
                    title: "🪙 BEP20 (BNB / USDT)",
                    address: "0x0954dc491c502849d04956ef74634aa5931a08e8",
                    icon: "bitcoinsign.circle.fill",
                    iconColor: .orange
                )
            }

            Text("感谢你支持 AirCard-iOS 的开发！❤️")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding(.horizontal)
    }
}

// MARK: - Support Popup Sheet (Startup Welcome)

struct SupportPopupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var dontShowOnLaunch: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Header Brand
                    VStack(spacing: 8) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.pink)

                        Text("欢迎使用 AirCard-iOS！")
                            .font(.title2.bold())

                        Text("免费开源 · 由 @mak5er 开发")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 8)

                    DonateView(isPopup: true, onDismiss: { dismiss() })

                    VStack(spacing: 12) {
                        Button {
                            dismiss()
                        } label: {
                            Text("进入 AirCard")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        Toggle(isOn: $dontShowOnLaunch) {
                            Text("启动时不再显示此弹窗")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 4)

                        Text("你可以随时在“关于与致谢”中打开捐赠选项 ❤️")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .padding(.vertical)
            }
            .navigationTitle("支持开发者")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}

// MARK: - Credits Sheet

struct CreditsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int

    init(initialTab: Int = 0) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("页面", selection: $selectedTab) {
                    Text("关于与致谢").tag(0)
                    Text("捐赠 ❤️").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 8)

                Divider()

                ScrollView {
                    if selectedTab == 0 {
                        creditsContent
                    } else {
                        VStack(spacing: 20) {
                            DonateView()
                            Spacer(minLength: 20)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle(selectedTab == 0 ? "关于与致谢" : "捐赠与支持")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .bold()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private var creditsContent: some View {
        VStack(spacing: 20) {
            // Header Brand
            VStack(spacing: 8) {
                Image(systemName: "creditcard.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("AirCard-iOS")
                    .font(.title2.bold())

                Text("钱包卡面与密码主题 · iOS 17.0 巨魔汉化版")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 10)

            // Donate banner inside credits
            Button {
                withAnimation {
                    selectedTab = 1
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.pink)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("支持 @mak5er 的开发")
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        Text("支持 PayPal 和加密货币捐赠")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(Color.pink.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Divider()

            VStack(alignment: .leading, spacing: 14) {
                // mak5er (Lead & Core Developer)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("主创与核心开发者", systemImage: "crown.fill")
                            .font(.caption.bold().uppercaseSmallCaps())
                            .foregroundStyle(.orange)
                        Spacer()
                        Text("主创")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.15))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())
                    }

                    HStack(spacing: 8) {
                        Text("@mak5er")
                            .font(.headline.bold())

                        Spacer()

                        Link(destination: URL(string: "https://github.com/mak5er")!) {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                Text("GitHub")
                            }
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)

                        Link(destination: URL(string: "https://x.com/mak5er")!) {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("Twitter / X")
                            }
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // merybist (Base IPA Developer)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("基础 IPA 开发者", systemImage: "hammer.fill")
                            .font(.caption.bold().uppercaseSmallCaps())
                            .foregroundStyle(.blue)
                        Spacer()
                        Text("基础开发")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.15))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }

                    HStack(spacing: 8) {
                        Text("@merybist")
                            .font(.headline.bold())

                        Spacer()

                        Link(destination: URL(string: "https://github.com/merybist")!) {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                Text("GitHub")
                            }
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)

                        Link(destination: URL(string: "https://x.com/merybist")!) {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("Twitter / X")
                            }
                            .font(.caption.bold())
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Technology acknowledgments
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.shield.fill")
                            .font(.title3)
                            .foregroundStyle(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("核心技术")
                                .font(.subheadline.bold())
                            Text("airlift（AirTraffic 同步沙盒逃逸）")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    HStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.title3)
                            .foregroundStyle(.purple)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("密码主题")
                                .font(.subheadline.bold())
                            Text(".passthm 主题标准（Cowabunga / Nugget）")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    HStack(spacing: 12) {
                        Image(systemName: "bolt.fill")
                            .font(.title3)
                            .foregroundStyle(.yellow)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("NeoSpring 与 PosterBoard")
                                .font(.subheadline.bold())
                            Text("桌面重载与 .tendies 壁纸（@neonmodder123、@skadz108、@rooootdev）")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(14)
                .background(Color(uiColor: .tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal)

            Spacer(minLength: 20)
        }
        .padding(.vertical)
    }
}

// MARK: - Pairing File Guide Sheet

struct PairingGuideSheet: View {
    @Environment(\.dismiss) private var dismiss
    var onImportTapped: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("在哪里找到配对文件")
                            .font(.title2.bold())
                        Text("AirCard-iOS 可以导入 SideStore、LiveContainer、iLoader 或电脑导出的配对文件。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // SideStore Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "app.badge.checkmark.fill")
                                .font(.title3)
                                .foregroundStyle(.blue)
                            Text("SideStore")
                                .font(.headline.bold())
                            Spacer()
                            Text("推荐")
                                .font(.caption2.bold())
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.blue.opacity(0.12))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }

                        Text("SideStore 会在设置时自动创建配对文件，你可以直接在“文件”App 中选择：")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("“文件”App 中的路径：")
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)
                            Text("我的 iPhone › SideStore › ALTPairingFile.mobiledevicepairing")
                                .font(.caption.monospaced())
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // LiveContainer Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "shippingbox.fill")
                                .font(.title3)
                                .foregroundStyle(.purple)
                            Text("LiveContainer（内置 SideStore）")
                                .font(.headline.bold())
                        }

                        Text("如果你在 LiveContainer 中运行 SideStore，配对文件位于 LiveContainer 的应用存储中：")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("“文件”App 中的路径：")
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)
                            Text("我的 iPhone › LiveContainer › SideStore › Documents › ALTPairingFile.mobiledevicepairing")
                                .font(.caption.monospaced())
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // iLoader / Jitterbug / AltStore Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.doc.fill")
                                .font(.title3)
                                .foregroundStyle(.orange)
                            Text("iLoader / Jitterbug / AltStore")
                                .font(.headline.bold())
                        }

                        Text("• iLoader：设置 › 导出配对文件 › 存储到“文件”。\n• Jitterbug：导出 <UDID>.mobiledevicepairing。\n• 电脑：运行 jitterbugpair，或从 SideServer / AltServer 导出，再传送到 iPhone。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // Direct Placement Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "folder.fill")
                                .font(.title3)
                                .foregroundStyle(.green)
                            Text("通过“文件”App 手动放入")
                                .font(.headline.bold())
                        }

                        Text("你也可以将 .mobiledevicepairing 或 .plist 文件直接复制到：")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Text("文件 App › 我的 iPhone › AirCard-iOS")
                            .font(.caption.monospaced())
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("文件会立即显示在 AirCard-iOS 的“文稿目录中发现的文件”下。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // Action Button
                    Button {
                        dismiss()
                        onImportTapped()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("立即导入配对文件")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(height: 48)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("配对指南")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }.bold()
                }
            }
        }
    }
}

// MARK: - Compact Scrollable Log View with 1-Click Copy

struct CompactLogView: View {
    let title: String
    let lines: [String]
    var onClear: (() -> Void)? = nil
    @State private var copied: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                if let onClear = onClear, !lines.isEmpty {
                    Button(action: onClear) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .padding(.trailing, 6)
                }
                Button {
                    UIPasteboard.general.string = lines.joined(separator: "\n")
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) {
                        copied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        var t2 = Transaction()
                        t2.disablesAnimations = true
                        withTransaction(t2) {
                            copied = false
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11, weight: .bold))
                        Text(copied ? "已复制" : "复制")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(copied ? .green : .blue)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
                }
                .buttonStyle(.borderless)
                .transaction { $0.animation = nil }
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(Array(lines.enumerated()), id: \.offset) { idx, line in
                            Text(line)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(logLineColor(line))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(idx)
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: 180)
                .background(Color(uiColor: .tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.secondary.opacity(0.18), lineWidth: 0.5)
                )
                .onChange(of: lines.count) { _, _ in
                    if !lines.isEmpty {
                        proxy.scrollTo(lines.count - 1, anchor: .bottom)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Native Document Picker

struct DocumentPickerView: UIViewControllerRepresentable {
    let allowedContentTypes: [UTType]
    let onPick: (URL) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let shouldStop = url.startAccessingSecurityScopedResource()
            defer {
                if shouldStop { url.stopAccessingSecurityScopedResource() }
            }
            parent.onPick(url)
            parent.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}

// MARK: - Root Tab View

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    @AppStorage("aircard.dont_show_support_on_launch") private var dontShowSupportOnLaunch: Bool = false
    @State private var showSupportPopup: Bool = false

    var body: some View {
        TabView(selection: $vm.selectedTab) {
            PairingTab()
                .tabItem { Label(TrollStoreAccess.enabled ? "访问权限" : "配对", systemImage: TrollStoreAccess.enabled ? "checkmark.shield" : "antenna.radiowaves.left.and.right") }
                .tag(AppTab.pairing)

            WalletCardsTab()
                .tabItem { Label("钱包卡片", systemImage: "creditcard.fill") }
                .tag(AppTab.walletCards)

            PasscodeThemeTab()
                .tabItem { Label("密码主题", systemImage: "lock.circle.fill") }
                .tag(AppTab.passcodeThemes)

            TendiesView()
                .tabItem { Label("壁纸", systemImage: "photo.stack.fill") }
                .tag(AppTab.wallpapers)
        }
        .alert("提示", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("确定") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .alert("操作成功！🎉", isPresented: $vm.showSuccessAlert) {
            Button("确定") {}
        } message: {
            Text(vm.successAlertMessage)
        }
        .sheet(isPresented: $vm.showShareSheet) {
            if let url = vm.exportedThemeURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $showSupportPopup) {
            SupportPopupSheet(dontShowOnLaunch: $dontShowSupportOnLaunch)
        }
        .onAppear {
            vm.showSuccessAlert = false
            vm.successAlertMessage = ""
            if !dontShowSupportOnLaunch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showSupportPopup = true
                }
            }
        }
    }
}

// MARK: - Pairing Tab

struct PairingTab: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showDeleteConfirm = false
    @State private var showCredits = false
    @State private var showFilePicker = false
    @State private var showPairingGuide = false

    private var isIOS27OrNewer: Bool {
        ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 27
    }

    private var isPotentiallyPatchedOS: Bool {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        if os.majorVersion > 27 { return true }
        if os.majorVersion == 27 && os.minorVersion >= 3 { return true }
        return false
    }

    var body: some View {
        Group {
            if TrollStoreAccess.enabled {
                TrollStoreSetupView()
            } else {
                pairingBody
            }
        }
    }

    private var pairingBody: some View {
        NavigationStack {
            Form {
                // Header
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "creditcard.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            Text("AirCard-iOS")
                                .font(.title2.bold())
                            Spacer()
                            Text("iOS \(ProcessInfo.processInfo.operatingSystemVersion.majorVersion) · v1.3.2")
                                .font(.caption.monospaced().bold())
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Color.blue.opacity(0.12))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }
                        Text("在设备上应用自定义钱包卡面和密码主题。原项目支持 iOS 18.0–27.2 beta 2（27.2 beta 3 起已修复相关漏洞）。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if isPotentiallyPatchedOS {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text("检测到 iOS 27.2 beta 3 或更新版本：Apple 已修复 AirTraffic 漏洞，操作可能失败。")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Network / VPN Status
                Section("网络") {
                    VPNStatusRow(vm: vm)
                }

                // Pairing Status
                Section("当前配对") {
                    HStack(spacing: 10) {
                        if vm.hasPairingFile {
                            Image(systemName: "checkmark.seal.fill").foregroundStyle(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("已准备就绪 ✅")
                                    .font(.subheadline.bold())
                                Text("\(vm.pairingFileName) (\(vm.pairingFileSizeString))")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("尚未配对")
                                    .font(.subheadline.bold())
                                Text(isIOS27OrNewer
                                     ? "在下方为此 iPhone 配对，或导入配对文件。"
                                     : "在下方导入 SideStore、iLoader 或电脑生成的配对文件。")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if vm.hasPairingFile {
                            Button(role: .destructive) {
                                showDeleteConfirm = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }

                    if vm.hasPairingFile {
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "trash.fill")
                                Text("删除配对文件")
                                Spacer()
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.red)
                        }
                    }
                }
                .confirmationDialog(
                    "删除当前配对？",
                    isPresented: $showDeleteConfirm,
                    titleVisibility: .visible
                ) {
                    Button("删除配对", role: .destructive) { vm.deletePairingFile() }
                    Button("取消", role: .cancel) {}
                } message: {
                    Text("将删除当前配对凭据，之后可以重新配对或导入其他文件。")
                }

                // Pairing File Import (SideStore / iLoader / PC)
                Section("配对文件") {
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            showFilePicker = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .foregroundStyle(.blue)
                                Text("导入配对文件…")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }

                        Button {
                            showPairingGuide = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle")
                                Text("在哪里找到 SideStore / LiveContainer 的配对文件？")
                            }
                            .font(.footnote)
                            .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)

                        Text("支持 SideStore、iLoader、AltStore、Jitterbug 或电脑导出的 .mobiledevicepairing、.plist 和 .mobilepair 文件。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if !vm.documentsPlistFiles.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("文稿目录中发现的文件：")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)

                            ForEach(vm.documentsPlistFiles, id: \.self) { filename in
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundStyle(.blue)
                                    Text(filename)
                                        .font(.caption.monospaced())
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    Spacer()
                                    Button("使用") {
                                        vm.selectPairingFile(filename: filename)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // On-Device Pairing Section (shown ONLY on iOS 27+)
                if isIOS27OrNewer {
                    Section("在此 iPhone 上配对") {
                        if vm.pairingPhase == .pairing {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    ProgressView().scaleEffect(0.85)
                                    Text(vm.pairingStatus.isEmpty ? "正在启动本地配对服务…" : vm.pairingStatus)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                if let pin = vm.pairingPIN {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("在此 iPhone 上输入以下配对码：")
                                            .font(.caption2.bold().uppercaseSmallCaps())
                                            .foregroundStyle(.secondary)

                                        HStack(alignment: .center, spacing: 0) {
                                            Text(pin)
                                                .font(.system(size: 40, weight: .black, design: .monospaced))
                                                .foregroundStyle(.orange)
                                            Spacer()
                                            Button {
                                                UIPasteboard.general.string = pin
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            } label: {
                                                Label("复制", systemImage: "doc.on.doc")
                                                    .font(.caption.bold())
                                            }
                                            .buttonStyle(.bordered)
                                            .tint(.orange)
                                        }

                                        Text("设置 › 隐私与安全性 › 开发者模式 › 与 AirCard-iOS 配对")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundStyle(.primary)

                                        Button {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(url)
                                            }
                                        } label: {
                                            Label("立即打开设置", systemImage: "arrow.up.forward.app")
                                                .bold()
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(.orange)
                                    }
                                    .padding(14)
                                    .background(Color.orange.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }

                                Button(role: .cancel) {
                                    vm.cancelPairing()
                                } label: {
                                    HStack(spacing: 8) {
                                        Spacer()
                                        Image(systemName: "xmark")
                                        Text("取消配对")
                                        Spacer()
                                    }
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        } else {
                            VStack(spacing: 12) {
                                if !vm.pairingStatus.isEmpty && vm.pairingStatus != "idle" {
                                    Text(vm.pairingStatus)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(
                                            vm.pairingStatus.contains("✅") ? .green :
                                            vm.pairingStatus.contains("❌") || vm.pairingStatus.contains("failed") ? .red :
                                            .secondary
                                        )
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }

                                Button {
                                    vm.startPairing()
                                } label: {
                                    HStack(spacing: 8) {
                                        Spacer()
                                        Image(systemName: "antenna.radiowaves.left.and.right")
                                            .font(.body.weight(.semibold))
                                        Text(vm.hasPairingFile ? "重新配对此 iPhone" : "配对此 iPhone")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .listRowInsets(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                        }
                    }
                }

                if !vm.log.isEmpty {
                    Section {
                        CompactLogView(
                            title: "运行日志（\(vm.log.count) 行）",
                            lines: vm.log,
                            onClear: { vm.log.removeAll() }
                        )
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .navigationTitle("AirCard-iOS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCredits = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                            Text("致谢与捐赠")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.pink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.pink.opacity(0.12))
                        .clipShape(Capsule())
                    }
                }
            }
            .sheet(isPresented: $showCredits) {
                CreditsSheet()
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPickerView(allowedContentTypes: [
                    UTType(filenameExtension: "mobiledevicepairing") ?? .data,
                    UTType(filenameExtension: "plist") ?? .propertyList,
                    UTType(filenameExtension: "mobilepair") ?? .data,
                    .propertyList,
                    .data,
                    .item
                ]) { url in
                    _ = vm.importPairingFile(from: url, originalName: url.lastPathComponent)
                }
            }
            .sheet(isPresented: $showPairingGuide) {
                PairingGuideSheet {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showFilePicker = true
                    }
                }
            }
            .onAppear {
                vm.refreshNetworkStatus()
                vm.refreshPairingFile()
            }
            .refreshable {
                vm.refreshNetworkStatus()
                vm.refreshPairingFile()
            }
        }
    }
}

// MARK: - VPN Status Row

struct VPNStatusRow: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: vm.vpnUp
                      ? "checkmark.shield.fill"
                      : "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(vm.vpnUp ? .green : .orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.vpnUp ? "回环 VPN 已连接" : "未检测到回环 VPN")
                        .font(.subheadline.bold())
                    Text(vm.vpnUp
                         ? "RSD 隧道已就绪，可以建立连接。"
                         : "应用主题前请连接 LocalDevVPN。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !vm.vpnUp {
                VStack(alignment: .leading, spacing: 6) {
                    Text("设置 LocalDevVPN：")
                        .font(.caption.bold())
                    ForEach([
                        "1. 打开 LocalDevVPN，点击“连接”。",
                        "2. 返回 AirCard-iOS，状态指示灯将变为绿色。"
                    ], id: \.self) { step in
                        Text(step)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Link("打开 LocalDevVPN",
                         destination: URL(string: "localdevvpn://")!)
                        .font(.caption.bold())
                }
                .padding(10)
                .background(Color.orange.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            HStack(spacing: 8) {
                Text("设备 IP：")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("10.7.0.1", text: $vm.deviceIP)
                    .font(.caption.monospaced())
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 120)
                Spacer()
                Button {
                    vm.refreshNetworkStatus()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }

            if !vm.networkDetail.isEmpty {
                Text(vm.networkDetail)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Apple Wallet Card View Component (Authentic AirCard Style)

struct WalletCardView: View {
    let card: CardItem
    let cardIndex: Int
    let onToggleSelected: (Bool) -> Void
    let onPickImage: () -> Void
    let onClearImage: () -> Void
    let onDelete: () -> Void
    var onRename: ((String) -> Void)? = nil

    @State private var copied = false
    @State private var isRenaming = false
    @State private var renameText = ""

    var body: some View {
        VStack(spacing: 12) {
            // Realistic Apple Wallet Card Mockup (1.586 : 1 aspect ratio)
            GeometryReader { geo in
                let width = geo.size.width
                let height = width / 1.586

                ZStack {
                    if let img = card.uiImage {
                        // Custom skin applied
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: height)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                            // Subtle Apple Wallet Card Gloss Overlay
                            LinearGradient(
                                colors: [.white.opacity(0.18), .clear, .black.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                            // Top Right Remove Button
                            Button(action: onClearImage) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white.opacity(0.95))
                                    .background(Circle().fill(Color.black.opacity(0.55)))
                            }
                            .buttonStyle(.plain)
                            .padding(10)
                        }
                    } else {
                        // Empty / Placeholder Card Mockup
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(uiColor: .secondarySystemBackground),
                                            Color(uiColor: .tertiarySystemBackground)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(
                                    Color.secondary.opacity(0.25),
                                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                                )

                            // Contactless & Chip icons
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "wave.3.right")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.secondary.opacity(0.6))
                                    Spacer()
                                    Image(systemName: "creditcard")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.secondary.opacity(0.5))
                                }
                                .padding(14)
                                Spacer()
                            }

                            // Center Action Callout
                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.blue)

                                Text("设置卡面")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)

                                Text("点击选择图片")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(width: width, height: height)
                .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                .contentShape(Rectangle())
                .onTapGesture { onPickImage() }
            }
            .aspectRatio(1.586, contentMode: .fit)

            // Card Controls & Meta Bar
            HStack(spacing: 8) {
                Toggle("", isOn: Binding(
                    get: { card.isSelected },
                    set: { onToggleSelected($0) }
                ))
                .labelsHidden()

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(card.title)
                            .font(.system(size: 13, weight: .bold))
                            .lineLimit(1)

                        if let network = card.paymentNetwork {
                            Text(network)
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.12))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }
                    }

                    // Monospace Hash Pill with Copy Button
                    HStack(spacing: 4) {
                        Text(card.id.prefix(8) + "…" + card.id.suffix(6))
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)

                        Button {
                            UIPasteboard.general.string = card.id
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            copied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                        } label: {
                            Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                                .font(.system(size: 10))
                                .foregroundStyle(copied ? .green : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()

                Button {
                    renameText = card.displayName ?? ""
                    isRenaming = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if card.uiImage != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 14))
                }

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 4)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(card.isSelected ? Color.blue.opacity(0.35) : Color.clear, lineWidth: 1.5)
        )
        .alert("重命名卡片", isPresented: $isRenaming) {
            TextField("卡片名称（例如：招商银行）", text: $renameText)
            Button("保存") {
                onRename?(renameText)
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("输入此卡片的自定义名称或银行名称。")
        }
    }
}

// MARK: - Wallet Cards Tab

struct WalletCardsTab: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var newHashText = ""
    @State private var showAddSheet = false
    enum ActiveCardPicker: Identifiable {
        case singleCard(String)
        case bulkAll
        var id: String {
            switch self {
            case .singleCard(let id): return id
            case .bulkAll: return "bulk_all"
            }
        }
    }
    @State private var activePicker: ActiveCardPicker? = nil
    @State private var showSourceDialog: Bool = false
    @State private var isPhotosPickerPresented: Bool = false
    @State private var isDocumentPickerPresented: Bool = false
    @State private var showCredits = false
    private struct CropRequest: Identifiable {
        let id = UUID()
        let image: UIImage
        let target: ActiveCardPicker
    }
    @State private var pendingCrop: CropRequest?
    @State private var cropRequest: CropRequest?
    @State private var photoLoadFailed = false
    @State private var pendingLoadError = false
    @State private var cropAccepted = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    scannerBanner

                    if vm.cards.isEmpty {
                        walletEmptyState
                            .padding(.top, 40)
                    } else {
                        cardsList
                    }
                }
                .padding(.vertical)
                .transaction { $0.animation = nil }
            }
            .transaction { $0.animation = nil }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("钱包卡片（\(vm.cards.count)）")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.toggleCardScanning()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: vm.isScanningCards ? "stop.circle.fill" : "wave.3.left.circle")
                            Text(vm.isScanningCards ? "停止扫描" : "扫描卡片")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(vm.isScanningCards ? .red : .blue)
                    }
                    .transaction { $0.animation = nil }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showAddSheet = true
                        } label: {
                            Label("手动添加卡片", systemImage: "plus")
                        }
                        if !vm.cards.isEmpty {
                            Button {
                                activePicker = .bulkAll
                                showSourceDialog = true
                            } label: {
                                Label("为所有卡片设置卡面…", systemImage: "photo.on.rectangle.angled")
                            }

                            Divider()

                            Button {
                                vm.selectAllCards(true)
                            } label: {
                                Label("全选", systemImage: "checkmark.circle")
                            }

                            Button {
                                vm.selectAllCards(false)
                            } label: {
                                Label("取消全选", systemImage: "circle")
                            }

                            Divider()

                            Button(role: .destructive) {
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                                    vm.clearAllCards()
                                }
                            } label: {
                                Label("清空所有卡片", systemImage: "trash")
                            }

                            Divider()

                            Button {
                                showCredits = true
                            } label: {
                                Label("致谢与捐赠", systemImage: "heart.fill")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    flashButton
                }
            }
            .sheet(isPresented: $showCredits) {
                CreditsSheet()
            }
            .sheet(isPresented: $showAddSheet) {
                AddCardSheet(hashText: $newHashText) {
                    vm.addCardHash(newHashText)
                    newHashText = ""
                    showAddSheet = false
                }
            }
            .confirmationDialog("选择图片来源", isPresented: $showSourceDialog, titleVisibility: .visible) {
                Button {
                    isPhotosPickerPresented = true
                } label: {
                    Label("照片图库", systemImage: "photo.on.rectangle")
                }
                Button {
                    isDocumentPickerPresented = true
                } label: {
                    Label("从“文件”中选择…", systemImage: "folder")
                }
                Button("取消", role: .cancel) {
                    activePicker = nil
                }
            }
            .sheet(isPresented: $isPhotosPickerPresented, onDismiss: { activePicker = nil }) {
                if let target = activePicker {
                    CardPhotoPicker { image in
                        assignImage(image, to: target)
                    }
                }
            }
            .sheet(isPresented: $isDocumentPickerPresented, onDismiss: presentPendingCrop) {
                DocumentPickerView(allowedContentTypes: [
                    .image, .png, .jpeg, .heic,
                    UTType(filenameExtension: "webp") ?? .image,
                    UTType(filenameExtension: "tiff") ?? .image
                ]) { url in
                    guard let picker = activePicker else { return }
                    if let data = try? Data(contentsOf: url),
                       let image = ImageEngine.safeImageFromData(data, maxDimension: 2560) {
                        pendingCrop = CropRequest(image: image, target: picker)
                    } else {
                        pendingLoadError = true
                    }
                    activePicker = nil
                }
            }
            .sheet(item: $cropRequest, onDismiss: {
                if !cropAccepted { isDocumentPickerPresented = true }
            }) { request in
                CardPhotoCropView(image: request.image) { croppedImage in
                    cropAccepted = true
                    assignImage(croppedImage, to: request.target)
                    activePicker = nil
                }
            }
            .alert("无法载入图片", isPresented: $photoLoadFailed) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("请选择其他图片，或先将照片下载到 iPhone。")
            }
        }
    }

    private func assignImage(_ image: UIImage, to target: ActiveCardPicker) {
        switch target {
        case .singleCard(let cardId):
            vm.setCardImage(for: cardId, image: image)
        case .bulkAll:
            vm.setSkinForAllCards(image: image)
        }
    }

    private func presentPendingCrop() {
        guard !isPhotosPickerPresented, !isDocumentPickerPresented else { return }
        if let request = pendingCrop {
            pendingCrop = nil
            cropAccepted = false
            activePicker = request.target
            cropRequest = request
        } else if pendingLoadError {
            pendingLoadError = false
            photoLoadFailed = true
        }
    }

    @ViewBuilder
    private var scannerBanner: some View {
        if vm.isScanningCards || !vm.scanStatusText.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if vm.isScanningCards {
                        ProgressView().scaleEffect(0.85)
                        Text("实时扫描已开启")
                            .font(.subheadline.bold())
                            .foregroundStyle(.blue)
                    } else {
                        Image(systemName: "wave.3.left.circle")
                            .foregroundStyle(.secondary)
                        Text("扫描状态")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if vm.isScanningCards {
                        Button("停止") {
                            vm.stopCardScanning()
                        }
                        .font(.caption.bold())
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .controlSize(.small)
                    }
                }
                Text(vm.scanStatusText)
                    .font(.caption)
                    .foregroundStyle(vm.scanStatusText.contains("停止") || vm.scanStatusText.contains("失败") || vm.scanStatusText.contains("出错") ? .orange : .secondary)
            }
            .padding(14)
            .background(vm.isScanningCards ? Color.blue.opacity(0.12) : Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal)
            .transaction { $0.animation = nil }
        }
    }

    @ViewBuilder
    private var cardsList: some View {
        VStack(spacing: 16) {
            ForEach(vm.cards, id: \.id) { card in
                let cardIndex = vm.cards.firstIndex(where: { $0.id == card.id }) ?? 0
                WalletCardView(
                    card: card,
                    cardIndex: cardIndex,
                    onToggleSelected: { isSelected in
                        vm.setCardSelected(id: card.id, selected: isSelected)
                    },
                    onPickImage: {
                        activePicker = .singleCard(card.id)
                        showSourceDialog = true
                    },
                    onClearImage: { vm.clearCardImage(for: card.id) },
                    onDelete: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        vm.deleteCard(id: card.id)
                    },
                    onRename: { newName in
                        vm.updateCardName(id: card.id, newName: newName)
                    }
                )
                .id(card.id)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                    removal: .scale(scale: 0.85).combined(with: .opacity)
                ))
            }

            if !vm.cardFlashLog.isEmpty {
                CompactLogView(
                    title: "应用日志（\(vm.cardFlashLog.count) 行）",
                    lines: vm.cardFlashLog,
                    onClear: { vm.cardFlashLog.removeAll() }
                )
                .padding(.top, 8)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var flashButton: some View {
        Button {
            vm.flashCards()
        } label: {
            HStack(spacing: 6) {
                if case .running = vm.cardFlashPhase {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.75)
                    Text("正在应用…")
                        .font(.system(size: 13, weight: .semibold))
                } else if case .done(let ok) = vm.cardFlashPhase, !ok {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12, weight: .semibold))
                    Text("重试")
                        .font(.system(size: 13, weight: .semibold))
                } else {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .semibold))
                    Text("应用")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
            .padding(.horizontal, 4)
            .frame(minHeight: 28)
        }
        .buttonStyle(.borderedProminent)
        .tint({
            if case .done(let ok) = vm.cardFlashPhase, !ok {
                return Color.orange
            }
            return Color.blue
        }())
        .disabled(!vm.canFlashCards || vm.cardFlashPhase == .running)
        .animation(.easeInOut(duration: 0.2), value: vm.cardFlashPhase)
    }

    private var walletEmptyState: some View {
        VStack(spacing: 18) {
            Image(systemName: "creditcard.viewfinder")
                .font(.system(size: 56))
                .foregroundStyle(.blue.opacity(0.8))

            Text("尚未发现卡片")
                .font(.title3.bold())

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    Text("1.")
                        .bold()
                        .foregroundStyle(.blue)
                    Text("点击上方工具栏中的**扫描卡片**。")
                }
                HStack(alignment: .top, spacing: 10) {
                    Text("2.")
                        .bold()
                        .foregroundStyle(.blue)
                    Text(TrollStoreAccess.enabled
                         ? "请保持 iPhone 解锁，巨魔会直接读取已保存的钱包卡片。"
                         : "连按侧边按钮打开 Apple Pay，通过面容 ID 验证后点击卡片。")
                }
                HStack(alignment: .top, spacing: 10) {
                    Text("3.")
                        .bold()
                        .foregroundStyle(.blue)
                    Text("扫描到的卡片会自动显示在这里！")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(16)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 24)

            HStack(spacing: 12) {
                Button {
                    vm.toggleCardScanning()
                } label: {
                    HStack(spacing: 6) {
                        Spacer()
                        Image(systemName: vm.isScanningCards ? "stop.circle.fill" : "wave.3.left.circle")
                        Text(vm.isScanningCards ? "停止扫描" : "扫描卡片")
                        Spacer()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(vm.isScanningCards ? .red : .blue)
                .transaction { $0.animation = nil }

                Button {
                    showAddSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Spacer()
                        Image(systemName: "plus")
                        Text("手动添加")
                        Spacer()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(.bordered)
                .transaction { $0.animation = nil }
            }
            .padding(.horizontal, 24)
            .transaction { $0.animation = nil }
        }
        .frame(maxWidth: .infinity)
        .transaction { $0.animation = nil }
    }
}

// MARK: - Add Card Sheet

struct AddCardSheet: View {
    @Binding var hashText: String
    let onAdd: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("卡片标识") {
                    TextField("粘贴卡片标识（例如 M6nDwZrkYbFl…）", text: $hashText, axis: .vertical)
                        .font(.system(.body, design: .monospaced))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .lineLimit(4...8)
                }
                Section {
                    Text("可以一次添加多个卡片标识，使用空格、逗号或换行分隔。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("添加卡片")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("添加") { onAdd() }
                        .disabled(hashText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .bold()
                }
            }
        }
    }
}

// MARK: - Passcode Theme Tab

struct PasscodeThemeTab: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showCredits = false

    var body: some View {
        NavigationStack {
            Form {
                // Mode picker
                Section {
                    Picker("模式", selection: $vm.passcodeMode) {
                        ForEach(CreatorMode.allCases) { mode in
                            Text(mode.displayTitle).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if vm.passcodeMode == .applyTheme {
                    ApplyThemeSection()
                } else {
                    ThemeCreatorSection()
                }

                // Flash log
                if !vm.passthmFlashLog.isEmpty {
                    Section {
                        CompactLogView(
                            title: "应用日志（\(vm.passthmFlashLog.count) 行）",
                            lines: vm.passthmFlashLog,
                            onClear: { vm.passthmFlashLog.removeAll() }
                        )
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            .navigationTitle("密码主题")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCredits = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.pink)
                    }
                }
            }
            .sheet(isPresented: $showCredits) {
                CreditsSheet()
            }
            .onAppear { vm.scanDocumentsDirectory() }
        }
    }
}

// MARK: Apply Theme section

struct ApplyThemeSection: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showDocumentPicker = false

    var body: some View {
        // Themes dropped directly into Documents folder
        if !vm.documentsThemes.isEmpty {
            Section("应用文件夹中的主题（我的 iPhone › AirCard-iOS）") {
                ForEach(vm.documentsThemes, id: \.self) { file in
                    HStack {
                        Image(systemName: "paintpalette.fill")
                            .foregroundStyle(.pink)
                        Text(file)
                            .font(.system(size: 13, design: .monospaced))
                        Spacer()
                        Button("载入") {
                            vm.loadPassthmFromDocuments(filename: file)
                        }
                        .font(.caption.bold())
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                }
            }
        }

        Section("浏览文件") {
            HStack {
                Button {
                    showDocumentPicker = true
                } label: {
                    Label(vm.loadedTheme == nil ? "从“文件”中选择 .passthm 主题…" : "更换 .passthm 主题…",
                          systemImage: "doc.badge.plus")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if vm.loadedTheme != nil {
                    Button {
                        vm.clearLoadedTheme()
                    } label: {
                        Text("清除")
                            .font(.caption.bold())
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPickerView(allowedContentTypes: [
                    UTType(filenameExtension: "passthm") ?? .archive,
                    UTType.zip,
                    UTType.archive
                ]) { url in
                    vm.loadPassthm(url: url)
                }
            }
        }

        if let theme = vm.loadedTheme {
            Section("交互式锁屏预览") {
                KeypadPreviewView(keys: theme.keysPreview)
                    .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .listRowBackground(Color.clear)
            }

            Section("主题信息") {
                LabeledContent("主题文件数", value: "\(theme.fileCount)")
                LabeledContent("已设置的数字", value: "\(theme.keysPreview.count) 个按键")

                Button {
                    vm.adoptThemeIntoCreator()
                } label: {
                    Label("在主题编辑器中编辑", systemImage: "pencil")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.bordered)
            }

            PasscodeTargetSection()

            Section {
                VStack(spacing: 12) {
                    flashButton

                    Button(role: .destructive) {
                        vm.clearLoadedTheme()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "trash")
                            Text("移除／卸载主题")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
            }
        }
    }

    @ViewBuilder
    private var flashButton: some View {
        if case .running = vm.passthmFlashPhase {
            HStack(spacing: 10) {
                ProgressView()
                VStack(alignment: .leading, spacing: 4) {
                    Text("正在应用主题…").font(.subheadline.bold())
                    ProgressView(value: vm.passthmFlashProgress)
                }
            }
            .padding(.vertical, 4)
        } else if case .done(let ok) = vm.passthmFlashPhase, !ok {
            Button {
                vm.flashPassthm()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                    Text("重新应用主题")
                    Spacer()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .disabled(!vm.canFlashPassthm)
        } else {
            Button {
                vm.flashPassthm()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "bolt.fill")
                    Text("将主题应用到 iPhone")
                    Spacer()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canFlashPassthm)
        }
    }
}

// MARK: - Passcode Target Section (matching AirCard macOS)

struct PasscodeTargetSection: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.badge.clock")
                        .foregroundColor(.blue)
                        .font(.headline)
                    Text("应用与语言设置")
                        .font(.headline)
                }

                // 1. Target System
                VStack(alignment: .leading, spacing: 4) {
                    Text("系统缓存")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    Picker("系统缓存", selection: $vm.targetTelephonyVersion) {
                        Text("TelephonyUI-10 (iOS 18+)").tag("TelephonyUI-10")
                        Text("TelephonyUI-9 (iOS 16–17)").tag("TelephonyUI-9")
                        Text("TelephonyUI-8 (iOS 14–15)").tag("TelephonyUI-8")
                        Text("通用（全部）").tag("all")
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }

                Divider()

                // 2. System Language
                VStack(alignment: .leading, spacing: 4) {
                    Text("系统语言")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    Picker("系统语言", selection: $vm.passcodeLanguageTarget) {
                        ForEach(PasscodeLanguageTarget.allCases) { item in
                            Text(item.displayTitle).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }

                Divider()

                // 3. Font Weight / Style
                VStack(alignment: .leading, spacing: 4) {
                    Text("字体粗细／样式")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    Picker("字体粗细／样式", selection: $vm.passcodeBoldTarget) {
                        ForEach(PasscodeBoldTarget.allCases) { item in
                            Text(item.displayTitle).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }

                // Dynamic hint
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: vm.passcodeLanguageTarget == .all && vm.passcodeBoldTarget == .both ? "globe" : "bolt.fill")
                        .font(.caption)
                        .foregroundColor(vm.passcodeLanguageTarget == .all && vm.passcodeBoldTarget == .both ? .secondary : .orange)
                        .padding(.top, 1)

                    if vm.passcodeLanguageTarget == .all && vm.passcodeBoldTarget == .both {
                        Text("通用模式会写入约 600 个文件，覆盖所有语言及粗体样式。选择指定语言可以加快应用速度。")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("快速模式：仅应用\(vm.passcodeLanguageTarget.displayTitle)，字体样式为\(vm.passcodeBoldTarget.displayTitle)。")
                            .font(.caption2)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: Theme Creator section

struct ThemeCreatorSection: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var selectedDigitForPicker: String? = nil
    @State private var showKeySourceDialog: Bool = false
    @State private var isKeyPhotosPickerPresented: Bool = false
    @State private var isKeyDocumentPickerPresented: Bool = false
    @State private var selectedKey: [PhotosPickerItem] = []

    @State private var showPosterSourceDialog: Bool = false
    @State private var isPosterPhotosPickerPresented: Bool = false
    @State private var isPosterDocumentPickerPresented: Bool = false
    @State private var selectedPoster: [PhotosPickerItem] = []

    var body: some View {
        Section("切片模式") {
            Picker("", selection: $vm.sliceMode) {
                ForEach(SliceMode.allCases) { m in
                    Text(m.displayTitle).tag(m)
                }
            }
            .pickerStyle(.segmented)
        }

        if vm.sliceMode == .posterSlice {
            posterSliceSection
        } else {
            individualKeysSection
        }

        // Preview
        Section("交互式锁屏预览") {
            KeypadPreviewView(keys: vm.effectiveKeys)
                .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                .listRowBackground(Color.clear)
        }

        PasscodeTargetSection()

        // Action Section
        Section {
            VStack(spacing: 12) {
                flashButton

                if !vm.effectiveKeys.isEmpty {
                    Button {
                        _ = vm.exportPassthm()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                            Text("导出 .passthm 主题…")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)

                    Button(role: .destructive) {
                        vm.clearAllCreator()
                    } label: {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "trash")
                            Text("全部清除")
                            Spacer()
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
        }
    }

    private var posterSliceSection: some View {
        Group {
            Section("整体背景图") {
                Button {
                    showPosterSourceDialog = true
                } label: {
                    Label(vm.posterImage == nil ? "选择键盘背景图片…" : "更换图片…",
                          systemImage: "photo")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .confirmationDialog("选择背景图片来源", isPresented: $showPosterSourceDialog, titleVisibility: .visible) {
                Button {
                    isPosterPhotosPickerPresented = true
                } label: {
                    Label("照片图库", systemImage: "photo.on.rectangle")
                }
                Button {
                    isPosterDocumentPickerPresented = true
                } label: {
                    Label("从“文件”中选择…", systemImage: "folder")
                }
                Button("取消", role: .cancel) {}
            }
            .photosPicker(
                isPresented: $isPosterPhotosPickerPresented,
                selection: $selectedPoster,
                maxSelectionCount: 1,
                matching: .images
            )
            .onChange(of: selectedPoster) { _, items in
                guard let item = items.first else { return }
                Task {
                    if let image = await item.loadUIImage(maxDimension: 2560) {
                        await MainActor.run { vm.setPosterImage(image) }
                    }
                    await MainActor.run { selectedPoster = [] }
                }
            }
            .sheet(isPresented: $isPosterDocumentPickerPresented) {
                DocumentPickerView(allowedContentTypes: [
                    .image, .png, .jpeg, .heic,
                    UTType(filenameExtension: "webp") ?? .image,
                    UTType(filenameExtension: "tiff") ?? .image
                ]) { url in
                    if let data = try? Data(contentsOf: url),
                       let image = ImageEngine.safeImageFromData(data, maxDimension: 2560) {
                        vm.setPosterImage(image)
                    }
                }
            }

            if vm.posterImage != nil {
                Section("切片样式") {
                    VStack(alignment: .leading, spacing: 6) {
                        Picker("", selection: $vm.maskToCircles) {
                            Text("无缝背景").tag(false)
                            Text("圆形按键").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: vm.maskToCircles) { _, _ in
                            vm.updatePosterSlicing()
                        }

                        Text(vm.maskToCircles ? "图片会裁剪为独立的圆形按键。" : "背景图片覆盖整个密码键盘，不进行圆形裁剪（Adobe Dog 风格）。")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 2)
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("缩放与构图")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("重置位置") {
                                withAnimation(.spring()) {
                                    vm.resetPosterPosition()
                                }
                            }
                            .font(.caption2)
                            .buttonStyle(.borderless)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "minus.magnifyingglass")
                                .foregroundColor(.secondary)
                                .font(.caption)

                            Slider(value: $vm.posterZoom, in: 0.5...3.0, step: 0.05)
                                .onChange(of: vm.posterZoom) { _, _ in
                                    vm.updatePosterSlicing()
                                }

                            Image(systemName: "plus.magnifyingglass")
                                .foregroundColor(.secondary)
                                .font(.caption)

                            Text(String(format: "%.1fx", vm.posterZoom))
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .frame(width: 38, alignment: .trailing)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "hand.draw")
                                .foregroundColor(.secondary)
                                .font(.caption2)
                            Text("在键盘预览中拖动以调整图片位置")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private var individualKeysSection: some View {
        Section("独立按键") {
            Text("点击按键行，为该按键设置自定义图片。")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(KeypadLayout.allButtons) { btn in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(width: 44, height: 44)
                        if let img = vm.customKeys[btn.digit] {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                        } else {
                            Text(btn.digit)
                                .font(.title3.bold())
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("按键 \(btn.digit)")
                            .font(.subheadline.weight(.medium))
                        if !btn.letters.isEmpty {
                            Text(btn.letters)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    if vm.customKeys[btn.digit] != nil {
                        Button(role: .destructive) {
                            vm.clearIndividualKey(digit: btn.digit)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.title3)
                        }
                        .buttonStyle(.borderless)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title3)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedDigitForPicker = btn.digit
                    showKeySourceDialog = true
                }
            }
        }
        .confirmationDialog("选择按键 \(selectedDigitForPicker ?? "") 的图片来源", isPresented: $showKeySourceDialog, titleVisibility: .visible) {
            Button {
                isKeyPhotosPickerPresented = true
            } label: {
                Label("照片图库", systemImage: "photo.on.rectangle")
            }
            Button {
                isKeyDocumentPickerPresented = true
            } label: {
                Label("从“文件”中选择…", systemImage: "folder")
            }
            Button("取消", role: .cancel) {
                selectedDigitForPicker = nil
            }
        }
        .photosPicker(
            isPresented: $isKeyPhotosPickerPresented,
            selection: $selectedKey,
            maxSelectionCount: 1,
            matching: .images
        )
        .onChange(of: selectedKey) { _, items in
            guard let item = items.first,
                  let digit = selectedDigitForPicker else {
                if items.isEmpty { selectedDigitForPicker = nil }
                return
            }
            let currentDigit = digit
            Task {
                if let image = await item.loadUIImage(maxDimension: 1024) {
                    await MainActor.run { vm.setIndividualKey(digit: currentDigit, image: image) }
                }
                await MainActor.run {
                    selectedKey = []
                    selectedDigitForPicker = nil
                }
            }
        }
        .sheet(isPresented: $isKeyDocumentPickerPresented) {
            DocumentPickerView(allowedContentTypes: [
                .image, .png, .jpeg, .heic,
                UTType(filenameExtension: "webp") ?? .image,
                UTType(filenameExtension: "tiff") ?? .image
            ]) { url in
                guard let digit = selectedDigitForPicker else { return }
                if let data = try? Data(contentsOf: url),
                   let image = ImageEngine.safeImageFromData(data, maxDimension: 1024) {
                    vm.setIndividualKey(digit: digit, image: image)
                }
                selectedDigitForPicker = nil
            }
        }
    }

    @ViewBuilder
    private var flashButton: some View {
        if case .running = vm.passthmFlashPhase {
            HStack(spacing: 10) {
                ProgressView()
                VStack(alignment: .leading, spacing: 4) {
                    Text("正在应用主题…").font(.subheadline.bold())
                    ProgressView(value: vm.passthmFlashProgress)
                }
            }
            .padding(.vertical, 4)
        } else if case .done(let ok) = vm.passthmFlashPhase, !ok {
            Button {
                vm.flashPassthm()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                    Text("重新应用主题")
                    Spacer()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .disabled(!vm.canFlashPassthm)
        } else {
            Button {
                vm.flashPassthm()
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "bolt.fill")
                    Text("将主题应用到 iPhone")
                    Spacer()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!vm.canFlashPassthm)
        }
    }
}

// MARK: - Keypad Preview (clean modern lock screen dialer preview)

struct KeypadPreviewView: View {
    @EnvironmentObject var vm: AppViewModel
    let keys: [String: UIImage]

    @State private var dragOffsetStart: CGPoint = .zero
    @State private var isDragging: Bool = false

    private func scaledPosterDimensions(for poster: UIImage, gridW: CGFloat, gridH: CGFloat) -> (width: CGFloat, height: CGFloat) {
        let imgW = poster.size.width
        let imgH = poster.size.height
        guard imgW > 0, imgH > 0 else { return (gridW, gridH) }

        let imgAspect = imgW / imgH
        let gridAspect = gridW / gridH

        if imgAspect > gridAspect {
            let h = gridH * vm.posterZoom
            return (width: h * imgAspect, height: h)
        } else {
            let w = gridW * vm.posterZoom
            return (width: w, height: w / imgAspect)
        }
    }

    var body: some View {
        let scale: CGFloat = 0.68
        let btnD: CGFloat = KeypadLayout.buttonDiameter * scale
        let colW: CGFloat = KeypadLayout.colWidth * scale
        let rowH: CGFloat = KeypadLayout.rowHeight * scale
        let gridW: CGFloat = KeypadLayout.gridWidth * scale
        let gridH: CGFloat = KeypadLayout.gridHeight * scale

        let isSeamlessPoster = (vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && !vm.maskToCircles && vm.posterImage != nil)

        ZStack {
            // Dark luxury frosted card backdrop
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.07, green: 0.07, blue: 0.09))

            LinearGradient(
                colors: [Color.white.opacity(0.06), Color.clear, Color.black.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            VStack(spacing: 12) {
                // Keypad grid
                ZStack {
                    // Layer 1: Background wallpaper in Seamless Poster mode
                    if isSeamlessPoster, let poster = vm.posterImage {
                        let dims = scaledPosterDimensions(for: poster, gridW: gridW, gridH: gridH)
                        Image(uiImage: poster)
                            .resizable()
                            .frame(width: dims.width, height: dims.height)
                            .position(
                                x: gridW / 2.0 + (vm.posterOffset.x * scale),
                                y: gridH / 2.0 + (vm.posterOffset.y * scale)
                            )
                    }

                    // Layer 2: 10 Keypad buttons
                    ForEach(KeypadLayout.allButtons) { btn in
                        let cx = CGFloat(btn.col) * colW + colW / 2
                        let cy = CGFloat(btn.row) * rowH + rowH / 2

                        keypadButton(btn: btn, btnD: btnD, scale: scale, isSeamlessPoster: isSeamlessPoster)
                            .position(x: cx, y: cy)
                    }
                }
                .frame(width: gridW, height: gridH)
                .clipped()
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { value in
                            if vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && vm.posterImage != nil {
                                if !isDragging {
                                    isDragging = true
                                    dragOffsetStart = vm.posterOffset
                                }
                                vm.posterOffset = CGPoint(
                                    x: dragOffsetStart.x + value.translation.width / scale,
                                    y: dragOffsetStart.y + value.translation.height / scale
                                )
                                vm.updatePosterSlicing()
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            dragOffsetStart = vm.posterOffset
                        }
                )

                // Drag hint pill (only shown when dragging poster is possible)
                if vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && vm.posterImage != nil {
                    HStack(spacing: 5) {
                        Image(systemName: "hand.draw.fill")
                            .font(.system(size: 10))
                        Text("拖动预览以调整位置")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.65))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.08)))
                }
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: (vm.passcodeMode == .themeCreator && vm.sliceMode == .posterSlice && vm.posterImage != nil) ? 320 : 295)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func keypadButton(btn: KeypadButtonGeometry, btnD: CGFloat, scale: CGFloat, isSeamlessPoster: Bool) -> some View {
        ZStack {
            if isSeamlessPoster {
                // Seamless mode: Frosted glass touch target ring
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: btnD, height: btnD)

                Circle()
                    .stroke(Color.white.opacity(0.35), lineWidth: 1.0)
                    .frame(width: btnD, height: btnD)

                VStack(spacing: 0) {
                    Text(btn.digit)
                        .font(.system(size: 26 * scale, weight: .light))
                        .foregroundStyle(.white.opacity(0.95))
                    if !btn.letters.isEmpty {
                        Text(btn.letters)
                            .font(.system(size: 8.5 * scale, weight: .semibold))
                            .tracking(0.8 * scale)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            } else if let img = keys[btn.digit] {
                // Custom theme button: Pure artwork without clashing superimposed text!
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: btnD, height: btnD)

                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: btnD, height: btnD)
                    .clipShape(Circle())

                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    .frame(width: btnD, height: btnD)
            } else {
                // Default iOS dialer style for unstyled buttons
                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: btnD, height: btnD)

                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    .frame(width: btnD, height: btnD)

                VStack(spacing: 0) {
                    Text(btn.digit)
                        .font(.system(size: 26 * scale, weight: .light))
                        .foregroundStyle(.white)
                    if !btn.letters.isEmpty {
                        Text(btn.letters)
                            .font(.system(size: 8.5 * scale, weight: .semibold))
                            .tracking(0.8 * scale)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }
        }
        .frame(width: btnD, height: btnD)
    }
}
