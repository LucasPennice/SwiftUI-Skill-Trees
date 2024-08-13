//
//  TreeNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import SwiftUI

struct NodeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addEllipse(in: rect)

        return path
    }
}

struct TreeNodeView: View {
    static let defaultSize = 45.0
    static let defaultIcon = "😄"
    static let defaultColor = Color.green

    let icon: String
    let size: CGFloat
    let color: Color

    @ViewBuilder var body: some View {
        ZStack {
            NodeShape()
                .fill(.black)
                .stroke(color, style: StrokeStyle(lineWidth: size * 0.05))
                .frame(width: size, height: size)

            Text(icon)
                .foregroundStyle(.white)
                .font(.system(size: size * 0.55))
        }
        .padding(1)
    }
}

#Preview {
    TreeNodeView(icon: "💀", size: 50.0, color: .green)
}
