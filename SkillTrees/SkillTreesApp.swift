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

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: ProgressTree.self)
    }

    init() {
        ///  Model Container Configuration
        do {
            container = try ModelContainer(for: ProgressTree.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }

        /// Revenue Cat Configuration
        Purchases.logLevel = .debug

        Purchases.configure(with: Configuration.builder(withAPIKey: RevenueCatConstants.apiKey).with(storeKitVersion: .storeKit2).build())

        Purchases.shared.delegate = PurchasesDelegateHandler.shared
    }
}
