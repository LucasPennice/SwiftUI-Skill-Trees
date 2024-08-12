//
//  SkillTreesApp.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import SwiftUI
import SwiftData

@main
struct SkillTreesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: ProgressTree.self)
    }
}
