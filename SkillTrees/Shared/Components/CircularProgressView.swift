//
//  CircularProgressView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import SwiftUI

struct CircularProgressView: View {
    var strokeColor = Color.green
    var bgColor = Color.gray
    var size = 18.0
    var progress = 0.22

    var body: some View {
        ZStack {
            Circle()
                .size(CGSize(width: size, height: size))
                .stroke(bgColor, style: StrokeStyle(lineWidth: size * 0.2, lineCap: .round))

            Circle()
                .size(CGSize(width: size, height: size))
                .trim(from: 1 - progress, to: 1)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: size * 0.2, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1), value: progress)
        }
        .frame(width: size, height: size)
        .frame(width: 30, height: 45)
    }
}

#Preview {
    CircularProgressView()
}
