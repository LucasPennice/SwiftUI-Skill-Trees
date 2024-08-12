//
//  Settings.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftUI

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
