//
//  RotatingCircularTreeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 27/08/2024.
//

import SwiftUI

struct RotatingCircularTreeView: View {
    @State private var rotation = 0.0
    @State private var progress = 0.0

    static let CircleSize = 45.0
    static let FrameSize = 250.0
    var distanceFromCenter: Double { (Self.FrameSize - Self.CircleSize) / 2 }

    let emojis: [String] = ["🍳", "🕺🏽", "♟️", "🧠", "🏋🏽", "🏃🏽‍♀️‍➡️", "🎼", "💰"]

    var body: some View {
        ZStack {
            Group {
                ForEach(0 ... 7, id: \.self) { i in
                    let angle = Double(i * 45)
                    Group {
                        Circle()
                            .frame(width: Self.CircleSize, height: Self.CircleSize)
                            .foregroundStyle(LinearGradient(colors: AppColors.titleGradient, startPoint: .bottomLeading, endPoint: .topTrailing))
                            .shadow(color: .black, radius: 5)

                        Text(emojis[i])
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                            .rotationEffect(.degrees(-rotation), anchor: .center)
                    }
                    .position(
                        x: 0 + Self.FrameSize / 2 + progress * distanceFromCenter * cos(angle * Double.pi / 180),
                        y: 0 + Self.FrameSize / 2 + progress * distanceFromCenter * sin(angle * Double.pi / 180)
                    )
                    .animation(.default.speed(0.5), value: progress)

                    .zIndex(1)

                    if i < 4 {
                        EdgeView(
                            startX: 0 + Self.FrameSize / 2,
                            startY: 0 + Self.FrameSize / 2 + distanceFromCenter - Self.CircleSize,
                            endX: 0 + Self.FrameSize / 2,
                            endY: 0 + Self.FrameSize / 2 - distanceFromCenter + Self.CircleSize
                        )
                        .stroke(AppColors.midGray, lineWidth: 6.4)
                        .scaleEffect(x: progress, y: progress)
                        .animation(.default.speed(0.5), value: progress)
                        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 0, z: 1))
                    }
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                    rotation += 360
                }
                withAnimation {
                    progress = 1
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 0, z: 1))

            RoundedRectangle(cornerSize: CGSize(width: 9, height: 9))
                .foregroundStyle(LinearGradient(colors: AppColors.titleGradient, startPoint: .bottomLeading, endPoint: .topTrailing))
                .frame(width: 52, height: 52)
                .rotationEffect(.degrees(45))
                .shadow(color: .black, radius: 5)
                .zIndex(2)
            
            Text("😁")
                .font(.system(size: 36))
                .zIndex(2)
        }
        .frame(width: Self.FrameSize, height: Self.FrameSize)
    }
}

#Preview {
    RotatingCircularTreeView()
}
