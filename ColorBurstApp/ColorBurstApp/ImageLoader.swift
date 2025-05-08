//
//  ImageLoader.swift
//  ColorBurstApp
//

import UIKit
import Nexus

struct ImageLoader {

    @MainActor
    func loadImage(size: Int = 300) async throws -> UIImage? {
        let request = ImageRequest(size: size)
        let data = try await request.fetchData()

        return UIImage(data: data)
    }
}

private struct ImageRequest: Request {
    let url: URL

    init(size: Int) {
        url = URL.loremPicsumURL(size: size)
    }
}

private extension URL {

    static func loremPicsumURL(size: Int) -> URL {
        if let url = URL(string: "https://picsum.photos/\(size)") {
            return url
        } else {
            fatalError("Invalid URL")
        }
    }
}
