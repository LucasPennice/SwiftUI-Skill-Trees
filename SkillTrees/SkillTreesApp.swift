//
//  SkillTreesApp.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import RevenueCat
import RevenueCatUI
import SwiftData
import SwiftUI

@main
struct SkillTreesApp: App {
    let container: ModelContainer

    @State var displayPaywall = false
    @StateObject var settings = Settings()

    func dismissPaywall() {
        displayPaywall = false
    }

    func showPaywall() {
        displayPaywall = true
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext, showPaywall: showPaywall)
                .preferredColorScheme(.dark)
                .environmentObject(settings)
                /// We display the paywall manually because it's a hard paywall and revenue cat does not let us present a paywall without a close button with this method
                /// Handles paywall display after the user completes onboarding, doesn't run when settings.onboardingFinished updates so we manually update displayPaywall once the user is onboarded
                .presentPaywallIfNeeded { customerInfo in
                    // Returning `true` will present the paywall
                    Task {
                        let onboardingFinished = await settings.onboardingFinished

                        if onboardingFinished && !customerInfo.entitlements.active.keys.contains(RevenueCatConstants.entitlementId) {
                            await showPaywall()
                        }
                    }

                    return false

                } purchaseCompleted: { _ in
                    dismissPaywall()
                } restoreCompleted: { _ in
                    dismissPaywall()
                }
                .fullScreenCover(isPresented: $displayPaywall) { PaywallView(displayCloseButton: false) }
        }
        .modelContainer(for: ProgressTree.self)
    }

    init() {
        ///  Model Container Configuration
        do {
            container = try ModelContainer(for: ProgressTree.self)
        } catch {
            fatalError("Failed to create ModelContainer for Progress Tree.")
        }

        /// Revenue Cat Configuration
        Purchases.logLevel = .debug

        Purchases.configure(with: Configuration.builder(withAPIKey: RevenueCatConstants.apiKey).with(storeKitVersion: .storeKit2).build())

        Purchases.shared.delegate = PurchasesDelegateHandler.shared
    }
}
