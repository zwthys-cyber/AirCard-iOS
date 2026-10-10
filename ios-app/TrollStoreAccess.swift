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
        throw NSError(domain: "TrollStoreAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "PosterBoard container could not be read. Install this build through TrollStore and unlock your iPhone."])
    }
}

struct TrollStoreSetupView: View {
    @State private var showCredits = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("AirCard · TrollStore", systemImage: "creditcard.circle.fill")
                        .font(.title2.bold())
                    Text("iOS 17.0 build · v1.3.2").foregroundStyle(.secondary)
                    Text("Wallet skins and passcode themes use direct file access. Pairing files and LocalDevVPN are not required.")
                }
                Section("Get started") {
                    Text("Install this IPA with TrollStore, then scan your cards in Wallet or create a passcode theme.")
                    Text("The passcode cache defaults to TelephonyUI-9 on iOS 17.")
                }
                Section("Compatibility") {
                    Text("This is an experimental port. Applying Wallet, passcode, and wallpaper changes still needs testing on your device.")
                }
                Section("Original files") {
                    Text("Files replaced by this build are backed up in AirCard-iOS › TrollStoreBackups in the Files app.")
                }
            }
            .navigationTitle("Access")
            .toolbar { Button("Credits") { showCredits = true } }
            .sheet(isPresented: $showCredits) { CreditsSheet() }
        }
    }
}
