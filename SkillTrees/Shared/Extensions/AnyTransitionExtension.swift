//
//  AnyTransitionExtension.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 24/08/2024.
//

import Foundation
import SwiftUI

struct BlurAnimationModifier: AnimatableModifier {
    var blur: Double

    var animatableData: Double {
        get { blur }
        set { blur = newValue }
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: animatableData)
    }
}

extension AnyTransition {
    static var blur: AnyTransition {
        AnyTransition.modifier(
            active: BlurAnimationModifier(blur: 5.0),
            identity: BlurAnimationModifier(blur: 0.0)
        )
    }
}
