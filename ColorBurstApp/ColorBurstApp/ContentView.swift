//
//  ContentView.swift
//  ColorBurstApp
//

import SwiftUI
import ColorBurst

struct ContentView: View {

    private let imageLoader = ImageLoader()

    @State private var image: UIImage?
    @State private var isLoading: Bool = false
    @State private var colorInfo = ColorInfo.standard

    var body: some View {
        ScrollView {
            contentView
        }
        .background(Gradient(colors: [colorInfo.backgroundColor, colorInfo.secondaryBackgroundColor]))
        .task {
            await refreshImage()
        }
        .onChange(of: image) {
            if let image {
                colorInfo = ColorBurst.extractColorInfo(from: image)
            } else {
                colorInfo = .standard
            }
        }
        .tint(colorInfo.secondaryColor)
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem Ipsum")
                    .font(.headline)
                    .foregroundStyle(colorInfo.secondaryColor)

                Text("Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .foregroundStyle(colorInfo.primaryColor)
            }

            Button {
                Task { await refreshImage() }
            } label: {
                Label("Refresh Image", systemImage: "arrow.clockwise.circle")
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .padding()
    }

    private func refreshImage() async {
        isLoading = true
        defer { isLoading = false }

        do {
            image = try await imageLoader.loadImage()
        } catch {
            image = nil
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
