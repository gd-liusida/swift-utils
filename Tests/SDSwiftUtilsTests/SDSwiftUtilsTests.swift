import Testing
@testable import SDSwiftUtils

@Test func safeCollectionAccess() {
    let values = ["a", "b"]
    #expect(values[safe: 0] == "a")
    #expect(values[safe: 2] == nil)
}

@Test func blankOptionalString() {
    let missing: String? = nil
    let whitespace: String? = "  \n"
    #expect(missing.isNilOrBlank)
    #expect(whitespace.isNilOrBlank)
}
