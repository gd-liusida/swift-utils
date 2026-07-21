import SDSwiftUtils
import SwiftUI

struct ContentView: View {
    private let values = ["Swift", "CocoaPods", "SDSwiftUtils"]

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "swift")
                .font(.system(size: 60))
                .foregroundStyle(.orange)

            Text("SDSwiftUtils")
                .font(.largeTitle.bold())

            Text("Version \(SDSwiftUtils.version)")
                .foregroundStyle(.secondary)

            Text(values[safe: 2] ?? "Not found")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.blue.opacity(0.12), in: Capsule())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
