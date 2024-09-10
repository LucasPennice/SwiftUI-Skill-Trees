//
//  OnboardingView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 27/08/2024.
//

import Mixpanel
import RevenueCatUI
import SwiftData
import SwiftUI

struct OnboardingView: View {
    var completeOnboarding: () -> Void

    @Environment(\.modelContext) var modelContext

    @State private var selectedKeys: [String] = []

    @Query var trees: [ProgressTree]

    let templates = ProgressTreeTemplates()

    @State private var currentStep = 0 {
        didSet {
            if currentStep == 3 {
                selectedKeys.forEach { key in
                    ProgressTreeTemplates.addTemplate(key, modelContext: modelContext)
                }
            }
        }
    }

    var filteredTemplates: [TemplatePreview] {
        return templates.templates.filter({ template in { selectedKeys.contains(where: { key in key == template.id }) }() })
    }

    var body: some View {
        TabView(selection: $currentStep) {
            OnboardingWelcomeView(moveToNextStep: { withAnimation { currentStep = 1 }})
                .tag(0)

            PickTemplatesAndEmailView(moveToNextStep: { withAnimation { currentStep = 2 }}, selected: $selectedKeys)
                .tag(1)

            CreatingTreesView(filteredTemplates: filteredTemplates, currentStep: currentStep, moveToNextStep: { withAnimation { currentStep = 3 }})
                .tag(2)

            VStack(alignment: .leading) {
                HStack {
                    Text("Your")
                        .font(.system(size: 28))
                        .fontWeight(.medium)

                    Text("JOURNEY")
                        .foregroundStyle(LinearGradient(colors: AppColors.titleGradient, startPoint: .bottomLeading, endPoint: .topTrailing))
                        .font(.system(size: 28))
                        .fontWeight(.bold)

                    Text("begins now")
                        .font(.system(size: 28))
                        .fontWeight(.medium)
                }
                .padding(.bottom)

                Text("Summary")
                    .opacity(0.5)

                ScrollView {
                    ForEach(trees) { tree in
                        ProgressTreeCardView(tree: tree)
                            .padding(.bottom)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize)
                .clipped()

                Button(action: {
                    Mixpanel.mainInstance().track(event: "Onboarding - Completed Onboarding")

                    withAnimation { completeOnboarding() }

                }) {
                    Text("Get my Plan")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView(completeOnboarding: {})
        .modelContainer(SwiftDataController.previewContainer)
}
