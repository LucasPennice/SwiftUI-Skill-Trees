//
//  SkillTreesApp.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

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
        do {
            container = try ModelContainer(for: ProgressTree.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
