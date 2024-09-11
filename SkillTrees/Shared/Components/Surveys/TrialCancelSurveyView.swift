//
//  TrialCancelSurveyView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/09/2024.
//

import SwiftUI

struct TrialCancelSurveyView: View {
    var completeTrialCancelSurvey: ([String], String) async -> Void

    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    ///
    /// UI State
    ///
    @State private var currentStep = 0
    @State private var isLoading = false
    ///
    /// Answer State
    ///
    @State private var answer1: [String] = []
    @State private var answer2: String = ""

    func closeSheet() async {
        withAnimation { isLoading = true }

        await completeTrialCancelSurvey(answer1, answer2)

        withAnimation { isLoading = false }

        dismiss()
    }

    var body: some View {
        TabView(selection: $currentStep) {
            VStack(alignment: .leading) {
                Text("👋 Hey friend! We saw you canceled your free trial")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Text("No hard feelings, but...")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Text("Would you mind letting us know the reason?")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .opacity(0.8)

                Spacer()

                List(["I’m not using Skill Trees anymore", "Hard to use", "The price is too high for me", "Missing features", "Other"], id: \.self) { text in
                    Button(action: {
                        if answer1.contains(where: { $0 == text }) { return withAnimation { answer1 = answer1.filter({ $0 != text }) }}

                        withAnimation { answer1.append(text) }
                    }) {
                        HStack {
                            Text(text)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)

                            Spacer()

                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                    .fill(AppColors.semiDarkGray)
                                    .frame(width: 21, height: 21)

                                if answer1.contains(where: { $0 == text }) {
                                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                        .fill(Color.accentColor)
                                        .frame(width: 15, height: 15)
                                        .transition(.blurReplace)
                                }
                            }
                        }
                        .frame(height: 25)
                        .padding()
                        .background(AppColors.midGray)
                        .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .scrollContentBackground(.hidden)
                .listStyle(InsetGroupedListStyle())
                .listRowSpacing(18)
                .environment(\.defaultMinListRowHeight, 10)
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)

                Spacer()

                Button(action: {
                    if answer1.contains(where: { $0 == "Other" }) {
                        return withAnimation { currentStep = 1 }
                    }

                    withAnimation { currentStep = 2 }

                }) {
                    Text("Continue")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .disabled(answer1.isEmpty)
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .tag(0)

            VStack(alignment: .leading) {
                Text("The reason I canceled my trial is:")
                    .font(.system(size: 22))
                    .fontWeight(.medium)

                Spacer()

                TextField("Your Answer", text: $answer2)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200, alignment: .top)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .tappableTextField()

                Spacer()

                Button(action: {
                    withAnimation { currentStep = 2 }
                }) {
                    Text("Done")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)
                .disabled(answer2.isEmpty)
            }
            .padding()
            .tag(1)

            VStack(alignment: .leading) {
                Text("😁 Thank for taking the time, friend!")
                    .font(.system(size: 22))
                    .fontWeight(.medium)

                Spacer()

                Button(action: {
                    Task {
                        await closeSheet()
                    }
                }) {
                    Text("Sure Thing")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .tag(2)
        }
        .ignoresSafeArea()
        .presentationBackgroundInteraction(.enabled)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .interactiveDismissDisabled()
    }
}

#Preview {
    TrialCancelSurveyView(completeTrialCancelSurvey: { _, _ in })
}
