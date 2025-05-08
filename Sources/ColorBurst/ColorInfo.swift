//
//  ColorInfo.swift
//  ColorBurst
//

import SwiftUI

// MARK: - ColorInfo

public struct ColorInfo {
    public let backgroundColor: Color
    public let secondaryBackgroundColor: Color
    public let primaryColor: Color
    public let secondaryColor: Color

    public init(backgroundColor: Color,
                secondaryBackgroundColor: Color,
                primaryColor: Color,
                secondaryColor: Color) {
        self.backgroundColor = backgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

// MARK: Convenience

public extension ColorInfo {

    static var standard: ColorInfo {
        ColorInfo(backgroundColor: Color(.systemBackground),
                  secondaryBackgroundColor: Color(.secondarySystemBackground),
                  primaryColor: .primary,
                  secondaryColor: .secondary)
    }
}

// MARK: Environment

public extension EnvironmentValues {
    @Entry var colorInfo: ColorInfo = .standard
}

public extension View {

    func colorInfo(_ colorInfo: ColorInfo) -> some View {
        self.environment(\.colorInfo, colorInfo)
    }
}
