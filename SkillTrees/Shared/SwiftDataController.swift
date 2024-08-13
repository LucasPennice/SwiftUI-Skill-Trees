//
//  SwiftDataController.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([ProgressTree.self])
            let container = try ModelContainer(for: schema, configurations: config)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
