//
//  PickTemplatesAndEmailView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 28/08/2024.
//

import Mixpanel
import RevenueCat
import SwiftUI

struct PickTemplatesAndEmailView: View {
    @EnvironmentObject var settings: Settings

    @State private var progress = 0.5

    @State private var hasPickedTemplates = false
    @State private var email = ""
    @State private var agreeToGetEmails = false

    @FocusState private var focusedField: Bool

    var moveToNextStep: () -> Void

    @Binding var selected: [String]

    let templates = ProgressTreeTemplates()

    func submit() {
        focusedField = false

        Purchases.shared.attribution.setAttributes(["$email": email])
        Mixpanel.mainInstance().people.set(properties: ["$email": email])
        settings.userEmail = email

        Mixpanel.mainInstance().track(event: "Onboarding - Complete Enter Email")

        moveToNextStep()
    }

    var allowToContinue: Bool {
        return (email.isValidEmailAddress() && agreeToGetEmails == true)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(AppColors.midGray)
                    .frame(width: 230, height: 3)
                    .offset(y: -5)

                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 230 * progress, height: 3)
                    .offset(y: -5)

                Circle()
                    .fill(Color.accentColor)
                    .stroke(.black, style: StrokeStyle(lineWidth: 3))
                    .frame(width: 12, height: 12)
                    .position(x: 0)

                Circle()
                    .fill(Color.accentColor)
                    .stroke(.black, style: StrokeStyle(lineWidth: 3))
                    .frame(width: 12, height: 12)
                    .position(x: 230 / 2)

                Circle()
                    .fill(progress == 1 ? Color.accentColor : AppColors.midGray)
                    .stroke(.black, style: StrokeStyle(lineWidth: 3))
                    .frame(width: 12, height: 12)
                    .position(x: 230)
                    .animation(.default.delay(0.4), value: progress)
            }
            .frame(width: 230, height: 10)

            if !hasPickedTemplates {
                VStack {
                    Text("Pick areas of your life to improve or \n where you have achievements")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.vertical, 5)

                    Text("We'll automatically generate Progress Trees \n You can customize them later")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .opacity(0.7)

                    List(templates.templates, id: \.self.id) { template in
                        Button(action: {
                            if selected.contains(where: { $0 == template.id }) { return withAnimation { selected = selected.filter({ $0 != template.id }) }}

                            withAnimation { selected.append(template.id) }
                        }

                        ) {
                            HStack {
                                Text(template.emojiIcon)
                                    .font(.system(size: 28))

                                Text(template.name)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)

                                Spacer()

                                ZStack {
                                    Circle()
                                        .fill(AppColors.midGray)
                                        .frame(width: 21, height: 21)

                                    if selected.contains(where: { $0 == template.id }) {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 15, height: 15)
                                            .transition(.blurReplace)
                                    }
                                }
                                .frame(width: 21, height: 21)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .listRowSpacing(18)
                    .environment(\.defaultMinListRowHeight, 10)
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollIndicators(.hidden)

                    Button(action: {
                        Mixpanel.mainInstance().track(event: "Onboarding - Complete Pick Templates")

                        withAnimation {
                            progress = 1
                            hasPickedTemplates = true
                        }
                    }) {
                        Text("Continue")
                            .fontWeight(.bold)
                            .frame(minWidth: 0, maxWidth: 290)
                            .frame(height: 34)
                    }
                    .disabled(selected.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .transition(.move(edge: .leading))
            } else {
                VStack {
                    Spacer()

                    Text("Last step, add an email to save your progress")
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)

                    VStack(alignment: .leading) {
                        TextField("Email", text: $email)
                            .frame(height: 45)
                            .padding(.horizontal)
                            .background(AppColors.midGray)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .focused($focusedField)
                            .submitLabel(.return)
                            .onSubmit {
                                focusedField = false

                                if allowToContinue == true {
                                    return DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation {
                                            submit()
                                        }
                                    }
                                }
                            }

                        Button(action: { withAnimation { agreeToGetEmails = true }}) {
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(AppColors.midGray)
                                    .frame(width: 21, height: 21)

                                if agreeToGetEmails {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 15, height: 15)
                                        .transition(.blurReplace)
                                }
                            }
                            .frame(width: 20, height: 20)
                            .padding(.trailing)

                            Text("I agree to get emails from the founder for feedback")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.white)
                                .opacity(0.7)
                        }
                    }
                    .padding()

                    Spacer()

                    Button(action: {
                        focusedField = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                submit()
                            }
                        }
                    }) {
                        Text("Continue")
                            .fontWeight(.bold)
                            .frame(minWidth: 0, maxWidth: 290)
                            .frame(height: 34)
                    }

                    .buttonStyle(.borderedProminent)
                    .disabled(!allowToContinue)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.top)
    }
}

#Preview {
    PickTemplatesAndEmailView(moveToNextStep: {}, selected: .constant([]))
}
