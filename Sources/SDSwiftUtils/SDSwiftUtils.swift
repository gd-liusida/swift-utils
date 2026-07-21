import Foundation

/// A namespace for utilities provided by SDSwiftUtils.
public enum SDSwiftUtils {
    /// The installed library version.
    public static let version = "0.1.1"
}

public extension Collection {
    /// Returns the element at `index`, or `nil` when the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension Optional where Wrapped == String {
    /// Returns `true` when the value is `nil`, empty, or only whitespace.
    var isNilOrBlank: Bool {
        self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
}
