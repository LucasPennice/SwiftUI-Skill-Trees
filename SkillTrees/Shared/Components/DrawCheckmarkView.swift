//
//  DrawCheckmarkView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftUI

struct DrawCheckmarkView: View {
    @State private var points: [CGPoint] = []
    @State private var showPath: Bool = false

    var runOnFingerLifted: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(AppColors.darkGray)
                .edgesIgnoringSafeArea(.all)
                .highPriorityGesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        if showPath == false {withAnimation {showPath = true}}
                        
                        self.addNewPoint(value)
                    })
                    .onEnded({ _ in
                        runOnFingerLifted()

                        withAnimation {showPath = false}

                        points = []
                    }))

            Image(systemName: "hand.draw")
                .font(.system(size: 30))
                .foregroundColor(.gray.opacity(0.2))
                .allowsHitTesting(false)

            if showPath {
                DrawShape(points: points)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.green)
                    .transition(.asymmetric(insertion: .opacity, removal: .slide.combined(with: .opacity).combined(with: .scale(scale: 0))))
                    .zIndex(2)
            }
        }
        .clipped()
        .sensoryFeedback(.success, trigger: points.isEmpty, condition: { old, new in
            old == true && new == false
        })
        .frame(width: 60, height: 60)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppColors.darkGray, lineWidth: 2)
        )
        .background(.clear)
    }

    private func addNewPoint(_ value: DragGesture.Value) {
        // here you can make some calculations based on previous points
        points.append(value.location)
    }
}

struct DrawShape: Shape {
    var points: [CGPoint]

    // drawing is happening here
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }

        path.move(to: firstPoint)
        for pointIndex in 1 ..< points.count {
            path.addLine(to: points[pointIndex])
        }
        return path
    }
}

#Preview {
    DrawCheckmarkView(runOnFingerLifted: {})
}
