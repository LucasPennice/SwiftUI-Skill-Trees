//
//  BlurBackground.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 25/08/2024.
//
import Foundation
import SwiftUI

open class UIBackdropView: UIView {
    override open class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

public struct Backdrop: UIViewRepresentable {
    public init() {}

    public func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }

    public func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

public struct Blur: View {
    public var radius: CGFloat
    public var opaque: Bool

    public init(radius: CGFloat = 3.0, opaque: Bool = false) {
        self.radius = radius
        self.opaque = opaque
    }

    public var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
    }
}
