//
//  ViewExtension.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
