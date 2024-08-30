//
//  OnboardingWelcomeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 27/08/2024.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @State private var showingText = false

    var moveToNextStep: () -> Void

    var body: some View {
        VStack {
            Spacer()

            RotatingCircularTreeView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.default) {
                            showingText = true
                        }
                    }
                }

            Spacer()

            if showingText {
                Group {
                    Text("SKILL TREES")
                        .font(.system(size: 48))
                        .fontWeight(.medium)
                        .foregroundStyle(LinearGradient(colors: AppColors.titleGradient, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .frame(height: 34)

                    Text("Visualize your achievements and reach \n your goals faster")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.vertical, 15)
                        .opacity(0.7)

                    Button(action: { moveToNextStep() }) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .frame(minWidth: 0, maxWidth: 290)
                            .frame(height: 34)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .transition(.blurReplace)
            }
        }
    }
}

#Preview {
    OnboardingWelcomeView(moveToNextStep: {})
}
