//
//  ForegroundColorInfo.swift
//  ColorBurst
//

import SwiftUI

// MARK: - ForegroundColorInfo

public struct ForegroundColorInfo {
    public let primaryColor: Color
    public let secondaryColor: Color

    public init(primaryColor: Color, secondaryColor: Color) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

// MARK: Convenience

public extension ForegroundColorInfo {

    static var standard: ForegroundColorInfo {
        ForegroundColorInfo(primaryColor: .primary,
                            secondaryColor: .secondary)
    }
}

// MARK: Environment

public extension EnvironmentValues {
    @Entry var foregroundColorInfo: ForegroundColorInfo = .standard
}

public extension View {

    func foregroundColorInfo(_ colorInfo: ForegroundColorInfo) -> some View {
        self.environment(\.foregroundColorInfo, colorInfo)
    }
}
