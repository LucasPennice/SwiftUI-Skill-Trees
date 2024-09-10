//
//  DrawCheckmarkView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftUI

struct DrawCheckMarkViewDimensions {
    let minWidth: CGFloat?
    let maxWidth: CGFloat?
    let height: CGFloat?

    init(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, height: CGFloat? = nil) {
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.height = height
    }
}

struct DrawCheckmarkView: View {
    @State private var points: [CGPoint] = []
    @State private var showPath: Bool = false

    var runOnFingerLifted: () -> Void

    var frameDimensions: DrawCheckMarkViewDimensions? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(AppColors.darkGray)
                .edgesIgnoringSafeArea(.all)
                .highPriorityGesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        if showPath == false { withAnimation { showPath = true }}

                        self.addNewPoint(value)
                    })
                    .onEnded({ _ in
                        runOnFingerLifted()

                        withAnimation { showPath = false }

                        points = []
                    }))

            Image(systemName: "checkmark")
                .font(.system(size: 30))
                .foregroundColor(AppColors.midGray)
                /// This frames width gives the impression of "drawing" the checkmark when it's width is less than 30
                .keyframeAnimator(
                    initialValue: CGFloat.zero,
                    content: { view, value in
                        view
                            .frame(width: value, height: 30, alignment: .leading)

                    },
                    keyframes: { _ in
                        CubicKeyframe(1.0, duration: 1.0)
                        LinearKeyframe(3.0, duration: 0.3)
                        CubicKeyframe(14.0, duration: 0.7)
                        /// Pause
                        LinearKeyframe(14.0, duration: 0.2)
                        /// Resume
                        CubicKeyframe(30.0, duration: 0.8)
                        /// Pause
                        LinearKeyframe(1.0, duration: 0.5)
                        /// Resume
                        LinearKeyframe(1.0, duration: 1.3)

                    })
                .clipped()
                .frame(width: 30, height: 30, alignment: .leading)
                .allowsHitTesting(false)

            Image(systemName: "hand.point.up.left.fill")
                .font(.system(size: 30))
                .foregroundColor(AppColors.midGray)
                .allowsHitTesting(false)
                .keyframeAnimator(
                    initialValue: AnimationValuesHand(),
                    content: { view, value in
                        view
                            .offset(x: value.horizontalTranslation,
                                    y: value.verticalTranslation
                            )
                            .rotationEffect(value.angle)

                    },
                    keyframes: { _ in
                        KeyframeTrack(\.horizontalTranslation) {
                            /// Duration 4.8
                            CubicKeyframe(0.0, duration: 1.0)
                            CubicKeyframe(-1.0, duration: 0.5)
                            CubicKeyframe(3.0, duration: 0.5)
                            /// Pause
                            LinearKeyframe(3.0, duration: 0.2)
                            /// Resume
                            CubicKeyframe(25.0, duration: 0.6)

                            LinearKeyframe(0.0, duration: 1.0)
                            LinearKeyframe(0.0, duration: 1.0)
                        }
                        KeyframeTrack(\.verticalTranslation) {
                            /// Duration 4.8
                            CubicKeyframe(0.0, duration: 1.0)
                            CubicKeyframe(12.0, duration: 0.5)
                            CubicKeyframe(22.5, duration: 0.5)
                            /// Pause
                            LinearKeyframe(22.5, duration: 0.2)
                            /// Resume
                            CubicKeyframe(6.0, duration: 0.6)

                            LinearKeyframe(0.0, duration: 1.0)
                            LinearKeyframe(0.0, duration: 1.0)
                        }

                        KeyframeTrack(\.angle) {
                            /// Duration 4.8
                            CubicKeyframe(.degrees(0), duration: 1.0)
                            CubicKeyframe(.degrees(-15), duration: 0.5)
                            CubicKeyframe(.degrees(-15), duration: 1.03)
                            LinearKeyframe(.degrees(0), duration: 0.9)
                            LinearKeyframe(.degrees(0), duration: 1.37)
                        }
                    })

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
        .frame(minWidth: frameDimensions?.minWidth ?? 60, maxWidth: frameDimensions?.maxWidth ?? 60)
        .frame(height: frameDimensions?.height ?? 60)
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

    struct AnimationValuesHand {
        var horizontalTranslation: CGFloat = 1.0
        var verticalTranslation: CGFloat = 0.0
        var angle: Angle = Angle.zero
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
