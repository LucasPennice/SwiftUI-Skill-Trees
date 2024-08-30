//
//  CreatingTreesView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 28/08/2024.
//

import SwiftUI

struct CreatingTreesView: View {
    var filteredTemplates: [TemplatePreview]

    var currentStep: Int

    var moveToNextStep: () -> Void

    var body: some View {
        VStack {
            Spacer()

            RotatingCircularTreeView()

            Spacer()

            Text("Creating your Progress Trees")
                .font(.system(size: 24))
                .fontWeight(.medium)

            Spacer()

            ScrollView {
                ForEach(filteredTemplates, id: \.self.id) { template in
                    LoadingTemplate(template: template, currentStep: currentStep)
                }
            }
            .frame(maxHeight: 300)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .clipped()

            Spacer()
        }
        .onChange(of: currentStep) {
            if currentStep == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation { moveToNextStep() }
                }
            }
        }
    }
}

struct LoadingTemplate: View {
    @State private var progress: Double = 0.01

    var template: TemplatePreview

    var currentStep: Int

    let delay = Double.random(in: 0 ... 1)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(template.emojiIcon)
                Text(template.name)

                Spacer()
            }

            ProgressView(value: progress)
                .scaleEffect(y: 1.2)
                .tint(template.color)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 77)
        .background(AppColors.midGray)
        .cornerRadius(10)
        .onChange(of: currentStep) {
            if currentStep == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 + delay) {
                    withAnimation(.easeInOut(duration: delay)) { progress = 1 }
                }
            }
        }
    }
}

#Preview {
    CreatingTreesView(filteredTemplates: [], currentStep: 2, moveToNextStep: {})
}
