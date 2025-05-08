//
//  Color+Extensions.swift
//  ColorBurst
//

import SwiftUI

package extension Color {

    func highestContrastColor(in colors: [Color] = [.black, .white]) -> Color? {
        colors.max { $0.contrastRatio(with: self) < $1.contrastRatio(with: self) }
    }

    func lowestContrastColor(in colors: [Color]) -> Color? {
        colors.min { $0.contrastRatio(with: self) < $1.contrastRatio(with: self) }
    }

    private func luminance() -> CGFloat {
        let (r, g, b, _) = toRGBComponents()

        func adjust(_ c: Double) -> Double {
            (c <= 0.03928) ? (c / 12.92) : pow((c + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * adjust(r) + 0.7152 * adjust(g) + 0.0722 * adjust(b)
    }

    private func contrastRatio(with color: Color) -> CGFloat {
        let lum1 = self.luminance()
        let lum2 = color.luminance()
        return (max(lum1, lum2) + 0.05) / (min(lum1, lum2) + 0.05)
    }
}

public extension Color {

    func toRGBComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let uiColor = UIColor(self)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red,
                       green: &green,
                       blue: &blue,
                       alpha: &alpha)

        return (r: red, g: green, b: blue, a: alpha)
    }

    func toHSBComponents() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        let uiColor = UIColor(self)

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue,
                       saturation: &saturation,
                       brightness: &brightness,
                       alpha: &alpha)

        return (h: hue, s: saturation, b: brightness, a: alpha)
    }
}
