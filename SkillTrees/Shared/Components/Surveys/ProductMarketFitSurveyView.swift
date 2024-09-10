//
//  ProductMarketFitSurveyView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 09/09/2024.
//

import StoreKit
import SwiftUI

struct ProductMarketFitSurveyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    ///
    /// UI State
    ///
    @State private var currentStep = 1
    ///
    /// Answer State
    ///
    @State private var answer1: String = ""
    @State private var answer2: String = ""
    @State private var answer3: String = ""
    @State private var answer4: String = ""
    @State private var answer5: String = ""

    func increaseStep() {
        currentStep = currentStep + 1
    }

    var body: some View {
        TabView(selection: $currentStep) {
            VStack(alignment: .leading) {
                Text("👋 Hey friend!")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Text("Can you help us see how we're doing?")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Text("How would you feel if you could no longer use Skill Trees?")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .opacity(0.8)

                Spacer()

                ForEach(["Very Disappointed", "Somewhat Disappointed", "Not Disappointed"], id: \.self) { text in
                    Button(action: {
                        if answer1 == text { return withAnimation { answer1 = "" }}

                        withAnimation { answer1 = text }
                    }) {
                        HStack {
                            Text(text)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)

                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(AppColors.semiDarkGray)
                                    .frame(width: 21, height: 21)

                                if answer1 == text {
                                    Circle()
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
                }
                .scrollContentBackground(.hidden)
                .listStyle(InsetGroupedListStyle())
                .listRowSpacing(18)
                .environment(\.defaultMinListRowHeight, 10)
                .scrollBounceBehavior(.basedOnSize)
                .scrollIndicators(.hidden)

                Spacer()

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("Continue")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .disabled(answer1.isEmpty)
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("I don't care")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(0)

            VStack(alignment: .leading) {
                Text("What type of people do you think would most benefit from Skill Trees? 🤔")
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
                    withAnimation { increaseStep() }

                }) {
                    Text("Next")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)
                .disabled(answer2.isEmpty)

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("No one")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(1)

            VStack(alignment: .leading) {
                Text("What is the main benefit you receive from Skill Trees? 📈")
                    .font(.system(size: 22))
                    .fontWeight(.medium)

                Spacer()

                TextField("Your Answer", text: $answer3)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200, alignment: .top)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .tappableTextField()

                Spacer()

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("Almost Done")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)
                .disabled(answer3.isEmpty)

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("I don't get anything from it")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(2)

            VStack(alignment: .leading) {
                Text("How can we improve Skill Trees for you? 💪")
                    .font(.system(size: 22))
                    .fontWeight(.medium)

                Spacer()

                TextField("Your Answer", text: $answer4)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200, alignment: .top)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .tappableTextField()

                Spacer()

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("One Last Thing")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .disabled(answer4.isEmpty)
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("I don't want it to improve")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(3)

            VStack(alignment: .leading) {
                Text("And finally, why do you love Skill Trees? 😻")
                    .font(.system(size: 22))
                    .fontWeight(.medium)

                Spacer()

                TextField("Your Answer", text: $answer5)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200, alignment: .top)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .tappableTextField()

                Spacer()

                Button(action: {
                    withAnimation { increaseStep() }

                }) {
                    Text("That's why")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .disabled(answer5.isEmpty)
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)

                Button(action: {
                    withAnimation { dismiss() }

                }) {
                    Text("I don't love Skill Trees")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(4)

            VStack(alignment: .leading) {
                Text("😁 Thank for taking the time, friend!")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Text("Would you mind doing us a last favor and pasting your answer as a review in the App Store?")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom)

                Spacer()

                Text("\"\(answer5)\"")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)

                Spacer()

                Button(action: {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = answer5

                    requestReview()

                    dismiss()

                }) {
                    Text("Sure Thing, copy to clipboard")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 34)
                }
                .disabled(answer5.isEmpty)
                .padding([.horizontal, .bottom])
                .buttonStyle(.borderedProminent)

                Button(action: {
                    dismiss()
                }) {
                    Text("I'm good")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 20)
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding()
            .tag(5)
        }
        .ignoresSafeArea()
        .presentationBackgroundInteraction(.enabled)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    ProductMarketFitSurveyView()
}
