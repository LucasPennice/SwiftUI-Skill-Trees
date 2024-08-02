//
//  DialoguePopUpView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import SwiftUI

struct DialoguePopUpView: View {
    let title: String
    let messages: [[String]]
    let buttonTitle: String
    let action: () -> Void

    @State private var showing: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .frame(maxWidth: .infinity)
                .fontWeight(.medium)
                .font(.system(size: 24))
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 30) {
                ForEach(0 ..< messages.count) { textBlockIdx in
                    HStack(spacing: 0) {
                        ForEach(0 ..< messages[textBlockIdx].count) { textIdx in
                            if messages[textBlockIdx][textIdx].contains("%BLUR%") {
                                Text(messages[textBlockIdx][textIdx].replacing("%BLUR%", with: ""))
                                    .font(.system(size: 16))
                                    .blur(radius: 8)
                            } else if messages[textBlockIdx][textIdx].contains("%BOLD%") {
                                Text(messages[textBlockIdx][textIdx].replacing("%BOLD%", with: ""))
                                    .font(.system(size: 16).bold())
                            } else {
                                Text(messages[textBlockIdx][textIdx])
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 30)

            Button(action: {
                let closeDurationSeconds = 0.5

                withAnimation(.spring(duration: closeDurationSeconds)) {
                    showing = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + closeDurationSeconds - 0.2) {
                    action()
                }

            }) {
                Text(buttonTitle)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .padding(.vertical, 25)
        .background(AppColors.semiDarkGray)
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(color: .black, radius: 10)
        .scaleEffect(showing ? 1 : 0.1)
        .offset(y: showing ? 0 : 1000)
        .blur(radius: showing ? 0 : 6)
        .onAppear {
            withAnimation {
                showing = true
            }
        }
    }
}

#Preview {
    DialoguePopUpView(title: "You've Unlocked Your First Fabric",
                      messages: [
                          ["There are ", "%BOLD%32", " Fabrics to unlock"],
                          ["The rarest is ", "%BOLD%BlaBLA"],
                          ["Each time you reach a milestone you get a roll to unlock new fabric"],
                          ["After completing your first Progress Tree you’ll unlock an", "%BLUR%Emblem", "to use your Fabrics on"],
                      ],
                      buttonTitle: "Continue",
                      action: {}
    )
}
