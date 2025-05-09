//
//  ColorBurst.swift
//  ColorBurst
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

// MARK: - ColorBurst

public enum ColorBurst {

    public static func extractColors(count: Int = 8, from image: UIImage) -> [Color] {
        guard let ciImage = CIImage(image: image) else { return [] }

        let filter = CIFilter.kMeans()
        filter.inputImage = ciImage
        filter.extent = ciImage.extent
        filter.count = count
        filter.passes = 8

        let output = filter.outputImage

        let colors = output?.colors ?? []
        let values = output?.values ?? []

        return zip(colors, values)
            .sorted { lhs, rhs in
                lhs.1 > rhs.1
            }.map {
                $0.0
            }
    }
}

// MARK: ColorInfo

public extension ColorBurst {

    static func extractColorInfo(from image: UIImage) -> ColorInfo {
        var colors = extractColors(from: image)

        guard !colors.isEmpty else { return .standard }

        let backgroundColor = colors.removeFirst()

        let secondaryBackgroundColor = backgroundColor.lowestContrastColor(in: colors)
        colors.removeAll { $0 == secondaryBackgroundColor }

        let primaryColor = backgroundColor.highestContrastColor(in: colors)
        colors.removeAll { $0 == primaryColor }

        let secondaryColor = backgroundColor.highestContrastColor(in: colors)

        let standard = ColorInfo.standard

        return ColorInfo(backgroundColor: backgroundColor,
                         secondaryBackgroundColor: secondaryBackgroundColor ?? standard.secondaryBackgroundColor,
                         primaryColor: primaryColor ?? standard.primaryColor,
                         secondaryColor: secondaryColor ?? standard.secondaryColor)
    }
}

// MARK: ForegroundColorInfo

public extension ColorBurst {

    static func extractColorInfo(from image: UIImage, backgroundColor: Color = Color(.systemBackground)) -> ForegroundColorInfo {
        let colors = extractColors(from: image)

        guard !colors.isEmpty else { return .standard }

        let lightColors = pickColors(colors: colors,
                                     backgroundColor: backgroundColor,
                                     scheme: .light)

        let darkColors = pickColors(colors: colors,
                                    backgroundColor: backgroundColor,
                                    scheme: .dark)

        let primary = Color(light: lightColors.primary,
                            dark: darkColors.primary)

        let secondary = Color(light: lightColors.secondary,
                              dark: darkColors.secondary)

        return ForegroundColorInfo(primaryColor: primary,
                                   secondaryColor: secondary)
    }

    private static func pickColors(colors: [Color], backgroundColor: Color, scheme: ColorScheme) -> (primary: Color, secondary: Color) {
        var colors = colors

        var environment = EnvironmentValues()
        environment.colorScheme = scheme

        let resolvedBGColor = Color(backgroundColor.resolve(in: environment))

        let primary = resolvedBGColor.highestContrastColor(in: colors) ?? .primary
        colors.removeAll { $0 == primary }

        let secondary = resolvedBGColor.highestContrastColor(in: colors) ?? .secondary

        return (primary, secondary)
    }
}
