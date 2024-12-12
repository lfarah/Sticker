//
//  File.swift
//  Sticker
//
//  Created by Benjamin Pisano on 15/11/2024.
//

#if os(iOS)
import SwiftUI
import Combine

public struct ContinuousHorizontalRotationMotionEffect: StickerMotionEffect {
    let intensity: Double
    let speed: Double // Rotations per second

    @State private var rotationAngle: Double = 0
    private let timer = Timer.publish(every: 1 / 60, on: .main, in: .common).autoconnect()
    @Environment(\.stickerShaderUpdater) private var shaderUpdater // Environment to update shader

    public func body(content: Content) -> some View {
        content
            .withViewSize { view, size in
                view
                    .rotation3DEffect(.degrees(rotationAngle), axis: (0, 1, 0))
                    .onReceive(timer) { _ in
                        rotationAngle += intensity * speed * (360 / 60)
                        if rotationAngle >= 360 {
                            rotationAngle -= 360 // Keep the angle within [0, 360]
                        }

                        // Update shader with new rotation values
                        shaderUpdater.update(
                            with: .init(
                                x: rotationAngle * size.width / 2,
                                y: 0 // Static Y-axis as this is only horizontal rotation
                            )
                        )
                    }
            }
    }
}

public extension StickerMotionEffect where Self == ContinuousHorizontalRotationMotionEffect {
    static func continuousHorizontalRotation(
        intensity: Double = 1,
        speed: Double = 0.5 // Default to 0.5 rotations per second
    ) -> Self {
        .init(
            intensity: intensity,
            speed: speed
        )
    }
}
#endif
