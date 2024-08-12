//
//  ContentView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import SwiftUI

class AppDateFormatter {
    static let shared = AppDateFormatter()

    var formatter: DateFormatter

    private init() {
        let nativeFormatter = DateFormatter()
        nativeFormatter.locale = .current
        nativeFormatter.dateStyle = .full
        nativeFormatter.timeStyle = .full

        formatter = nativeFormatter
    }
}

class Settings: ObservableObject {
    @AppStorage("appFirstOpenDateString") var appFirstOpenDateString: String = ""
    @AppStorage("doNotShowDiscordPopUpAgain") var doNotShowDiscordPopUpAgain: Bool = false
    @AppStorage("startDateString") var startDateString: String = ""
    @AppStorage("lastLogInDateString") var lastLogInDateString: String = ""
    /// We have a variable instead of a derived variable because the content transition doesn't work otherwise
    @AppStorage("streakDays") var streakDays: Int = 3

    var appFirstOpenDate: Date {
        return AppDateFormatter.shared.formatter.date(from: appFirstOpenDateString) ?? .now
    }

    var daysSinceFirstOpen: Int {
        let diff = Calendar.current.dateComponents([.day], from: appFirstOpenDate, to: .now)

        return diff.day ?? 0
    }

    func updateStreak() {
        let lastLogIn = AppDateFormatter.shared.formatter.date(from: lastLogInDateString) ?? .now

        let diff = Calendar.current.dateComponents([.day], from: .now, to: lastLogIn)

        guard let diff = diff.day else { return }

        /// We are logging on the same day as the last log in
        if diff == 0 { }

        /// We are logging a day after the last log in, the streak is still valid and increases by one
        if diff == 1 {
            withAnimation {
                streakDays = self.streakDays + 1
            }
        }

        /// We are logging more than a day after the last log in, the streak is no longer valid, therefore it resets
        if diff > 1 {
            startDateString = AppDateFormatter.shared.formatter.string(from: .now)

            withAnimation {
                streakDays = 0
            }
        }

        lastLogInDateString = AppDateFormatter.shared.formatter.string(from: .now)
    }

    init() {
        /// If there is no set first open date we set that to today
        if appFirstOpenDateString.isEmpty {
            appFirstOpenDateString = AppDateFormatter.shared.formatter.string(from: .now)
        }

        /// If there is no set last open date we set that to 3 days before today. Because we want the user to start with a streak of 3
        if startDateString.isEmpty {
            startDateString = AppDateFormatter.shared.formatter.string(from: Calendar.current.date(byAdding: .day, value: -3, to: .now)!)
        }

        /// If there is no last log in we set that to today
        if lastLogInDateString.isEmpty {
            lastLogInDateString = AppDateFormatter.shared.formatter.string(from: .now)
        }
    }
}

struct ContentView: View {
    @State private var showingCollectionNotAvailablePopUp: Bool = false
    @State private var showingAddNewTreePopUp: Bool = false

    @StateObject var settings = Settings()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        HStack {
                            Image(systemName: "flame")
                                .font(.system(size: 18))
                                .foregroundStyle(AppColors.textGray)

                            Text("\(settings.streakDays)")
                                .fontWeight(.medium)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())
                        }
                        .frame(height: 33)
                        .padding(.horizontal)
                        .background(AppColors.darkGray)
                        .cornerRadius(15)

                        Spacer()

                        Button("", systemImage: "gear") {}
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Progress Trees")
                            .foregroundStyle(.white)
                            .font(.system(size: 34).bold())

                        Spacer()

                        Button("Add") { showingAddNewTreePopUp = true }
                            .font(.system(size: 18))
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .foregroundColor(.accentColor)
                            .background(.blue.opacity(0.3))
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)

                    List {
                        ///
                        /// JOIN COMMUNITY BUTTON
                        /// Visible only after the user uses the app for 3 days
                        /// After the user presses the close button it should show up again
                        /// Tapping it takes you to the discord server (🚨 NOT IMPLEMENTED)
                        ///
                        if settings.daysSinceFirstOpen >= 3 && !settings.doNotShowDiscordPopUpAgain {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("We’d love to hear your thoughts")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)

                                    Text("Tap here to join our Discord")
                                        .font(.system(size: 14))
                                        .foregroundStyle(AppColors.textGray)
                                }

                                Spacer()

                                Image(systemName: "xmark")
                                    .font(.system(size: 14).bold())
                                    .foregroundColor(AppColors.textGray)
                                    .frame(width: 24, height: 24)
                                    .background(AppColors.darkGray)
                                    .cornerRadius(20)
                                    .onTapGesture { withAnimation { settings.doNotShowDiscordPopUpAgain = true } }
                            }
                            .listRowBackground(AppColors.semiDarkGray)
                        }

                        ///
                        /// OPEN COLLECTION BUTTON
                        /// Navigates only after the user earns their first collectible (🚨 NOT IMPLEMENTED)
                        /// Lock icon goes away after the user earns their first collectible (🚨 NOT IMPLEMENTED)
                        ///
                        if false {
                            NavigationLink(destination: Text("Hello, World!")) {}
                                .opacity(0)
                                .background(
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(AppColors.textGray)

                                        Text("Collection")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 7)
                                            .foregroundColor(AppColors.textGray)
                                    }
                                )
                                .listRowBackground(AppColors.semiDarkGray)
                        } else {
                            Button(action: { showingCollectionNotAvailablePopUp = true }) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(AppColors.textGray)

                                    Text("Collection")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 7)
                                        .foregroundColor(AppColors.textGray)
                                }
                            }
                            .listRowBackground(AppColors.semiDarkGray)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .listRowSpacing(18)
                    .scrollBounceBehavior(.basedOnSize)
                    .offset(y: -35)
                }
                .padding(.vertical)
                .background(.black)
                .allowsHitTesting(!showingCollectionNotAvailablePopUp)

                #warning("SI EL USUARIO NO TIENEN NINGUN PROGRESS TREE EL POPUP ESTE TE DEBERIA REDIRIGIR, CAMBIAR MENSAJE BOTON Y ACTION")
                if showingCollectionNotAvailablePopUp {
                    DialoguePopUpView(
                        title: "Get your first Fiber to unlock your Collection",
                        messages: [["Complete a milestone in any Progress Tree to get your first Fiber"]],
                        buttonTitle: "Continue",
                        action: { showingCollectionNotAvailablePopUp = false }
                    )
                }
            }
            .sheet(isPresented: $showingAddNewTreePopUp) {
                AddNewProgressTreeView()
            }
        }
        .environmentObject(settings)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            settings.updateStreak()
        }
    }
}

#Preview {
    ContentView()
}
