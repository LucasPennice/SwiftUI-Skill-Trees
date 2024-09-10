//
//  ViewModifiers.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 10/09/2024.
//

import Foundation
import SwiftUI

struct TappableTextField: ViewModifier {
    @FocusState private var textFieldFocused: Bool

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture { textFieldFocused = true }
            .focused($textFieldFocused)
    }
}

extension View {
    func tappableTextField() -> some View {
        modifier(TappableTextField())
    }
}
