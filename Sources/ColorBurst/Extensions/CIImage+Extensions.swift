//
//  CIImage+Extensions.swift
//  ColorBurst
//

import CoreImage
import SwiftUI

package extension CIImage {

    var values: [UInt8] {
        let context = CIContext()

        guard let cgImage = context.createCGImage(self, from: extent) else { return [] }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.alphaInfo.rawValue

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return [] }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var values: [UInt8] = []

        for i in stride(from: 0, to: pixelData.count, by: bytesPerPixel) {
            values.append(pixelData[i + 3])
        }

        return values
    }

    var colors: [Color] {
        let context = CIContext()

        guard let cgImage = context.createCGImage(self.settingAlphaOne(in: extent), from: extent) else { return [] }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.alphaInfo.rawValue

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return [] }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colors: [Color] = []

        for i in stride(from: 0, to: pixelData.count, by: bytesPerPixel) {
            let value = Double(pixelData[i + 3])

            let r = Double(pixelData[i + 0]) / value
            let g = Double(pixelData[i + 1]) / value
            let b = Double(pixelData[i + 2]) / value
            let a = Double(pixelData[i + 3]) / value
            colors.append(Color(red: r, green: g, blue: b, opacity: a))
        }

        return colors
    }
}
