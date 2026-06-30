import Foundation

enum InputSourceShortLabel {
  static func make(
    inputSourceID: String,
    inputModeID: String,
    localizedName: String
  ) -> String {
    if let label = labelForKnownID(inputSourceID) {
      return label
    }

    if let label = labelForKnownID(inputModeID) {
      return label
    }

    let normalizedName = localizedName.folding(
      options: [.caseInsensitive, .diacriticInsensitive],
      locale: .current
    ).lowercased()

    if normalizedName.contains("abc")
      || normalizedName.contains("u.s.")
      || normalizedName.contains("english")
      || normalizedName.contains("british")
    {
      return "EN"
    }

    if let lastComponent = inputSourceID.split(separator: ".").last {
      return shortLabel(String(lastComponent))
    }

    return shortLabel(localizedName)
  }

  private static func labelForKnownID(_ value: String) -> String? {
    let knownPrefixes: [(String, String)] = [
      ("com.apple.keylayout.ABC", "EN"),
      ("com.apple.keylayout.US", "EN"),
      ("com.apple.keylayout.British", "EN"),
      ("com.apple.keylayout.Dvorak", "EN"),
      ("com.apple.inputmethod.Roman", "EN"),
      ("com.apple.keylayout.German", "DE"),
      ("com.apple.keylayout.French", "FR"),
      ("com.apple.keylayout.Italian", "IT"),
      ("com.apple.keylayout.Spanish", "ES"),
      ("com.apple.keylayout.Swedish", "SV"),
      ("com.apple.keylayout.Portuguese", "PT"),
      ("com.apple.keylayout.Kazakh", "KK"),
      ("com.apple.inputmethod.Japanese", "JP"),
      ("com.apple.inputmethod.Korean", "KO"),
      ("com.apple.inputmethod.TCIM", "ZH"),
      ("com.apple.inputmethod.SCIM", "ZH"),
    ]

    for (prefix, label) in knownPrefixes where value.hasPrefix(prefix) {
      return label
    }

    return nil
  }

  private static func shortLabel(_ value: String) -> String {
    let compact = String(value.filter { $0.isLetter || $0.isNumber })
      .uppercased()

    if compact.isEmpty {
      return "--"
    }

    if compact.count <= 3 {
      return compact
    }

    return String(compact.prefix(2))
  }
}
