//
//  EdgeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 17/08/2024.
//

import SwiftUI

struct EdgeView: Shape {
    var startX: Double
    var startY: Double
    var endX: Double
    var endY: Double

    var animatableData: AnimatablePair<Double, AnimatablePair<Double, AnimatablePair<Double, Double>>> {
        get { AnimatablePair(startX, AnimatablePair(startY, AnimatablePair(endX, endY))) }
        set {
            startX = newValue.first
            startY = newValue.second.first
            endX = newValue.second.second.first
            endY = newValue.second.second.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Top left
        path.move(to: CGPoint(x: startX, y: startY + TreeNodeView.defaultSize / 2))
        // Curve
        path.addCurve(
            to: CGPoint(x: endX, y: endY - TreeNodeView.defaultSize / 2),
            control1: CGPoint(x: startX, y: startY - 0.75 * (startY - endY)),
            control2: CGPoint(x: endX, y: endY - 0.38 * (endY - startY))
        )

        return path
    }
}
