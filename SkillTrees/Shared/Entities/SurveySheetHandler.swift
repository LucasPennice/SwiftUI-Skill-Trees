//
//  SurveySheetHandler.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 09/09/2024.
//

import Foundation
import Mixpanel
import RevenueCat
import SwiftData
import SwiftUI

/// Keys from the network response we get from calling the backend survey handler endpoint
struct SurveySheetResponse: Codable {
    let completedCancelTrialSurvey: Bool
}

class SurveySheetHandler: ObservableObject {
    ///
    /// Stored Survey Data
    ///
    @AppStorage("shownTrialCancelSurvey") var shownTrialCancelSurvey: Bool = false
    @AppStorage("shownProductMarketFitSurvey") var shownProductMarketFitSurvey: Bool = false
    /// Trigger on app active
    @Published var showingTrialCancelSurvey = false
    /// Shown after user makes progress on 3 milestones
    @Published var showingProductMarketFitSurvey = false

    func completeProductMarketFitSurvey(
        _ answer1: String,
        _ answer2: String,
        _ answer3: String,
        _ answer4: String,
        _ answer5: String
    ) {
        showingProductMarketFitSurvey = false
        shownProductMarketFitSurvey = true

        Mixpanel.mainInstance().track(
            event: "Complete Product Market Fit Survey",
            properties: [
                "How would you feel if you could no longer use Skill Trees?": answer1,
                "What type of people do you think would most benefit from Skill Trees?": answer2,
                "What is the main benefit you receive from Skill Trees?": answer3,
                "How can we improve Skill Trees for you?": answer4,
                "Why do you love Skill Trees?": answer5,
            ]
        )
    }

    func closeTrialCancelSurvey() {
        showingTrialCancelSurvey = false
        shownTrialCancelSurvey = true
    }

    func completeTrialCancelSurvey(_ cancelReasons: [String]) async throws {
        Mixpanel.mainInstance().track(
            event: "Complete Trial Cancel Survey",
            properties: [
                "Reasons": cancelReasons,
            ]
        )

        /// Update database
        do {
            let customerInfo = try await Purchases.shared.customerInfo()

            if let url = URL(string: "https://server.skilltreesapp.com/api/surveys/complete_cancel_trial_survey/\(customerInfo.originalAppUserId)") {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    // Handle the response
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {
                        print("Response status code: \(httpResponse.statusCode)")
                    }

                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }

                // Start the task
                task.resume()
            }

        } catch {
            print(error)
        }
    }

    /// This function is called anytime the app becomes active
    func runOnAppActive(countCompleteOrProgressedNodes: @escaping () -> Int) async {
        do {
            if !shownTrialCancelSurvey {
                let customerInfo = try await Purchases.shared.customerInfo()

                if let url = URL(string: "https://server.skilltreesapp.com/api/surveys/\(customerInfo.originalAppUserId)") {
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "GET"

                    let (data, response) = try await URLSession.shared.data(from: url)

                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    }

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let parsedResponse = try decoder.decode(SurveySheetResponse.self, from: data)

                    await MainActor.run {
                        if parsedResponse.completedCancelTrialSurvey == false {
                            showingTrialCancelSurvey = true

                            return
                        }
                    }
                }
            }

            if !shownProductMarketFitSurvey {
                let completeOrProgressedNodes = countCompleteOrProgressedNodes()

                await MainActor.run {
                    if completeOrProgressedNodes >= 3 {
                        showingProductMarketFitSurvey = true

                        return
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
