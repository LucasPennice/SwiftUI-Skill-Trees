//
//  ContentViewVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        ///
        /// Data
        ///
        var modelContext: ModelContext
        var progressTrees = [ProgressTree]()
        ///
        /// UI State
        ///
        var showingCollectionNotAvailablePopUp: Bool = false
        var showingAddNewTreePopUp: Bool = false
        var path = NavigationPath()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<ProgressTree>()
                progressTrees = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }

        func addProgressTree(_ tree: ProgressTree) {
            modelContext.insert(tree)

            let rootNode = TreeNode(progressTree: tree, unit: "", amount: 0.0, complete: false, progressiveQuest: false, name: tree.name, emojiIcon: tree.emojiIcon, items: [], completionHistory: [])

            tree.treeNodes.append(rootNode)

            fetchData()
        }

        func deleteTree(tree: ProgressTree) {
            modelContext.delete(tree)

            fetchData()
        }
    }
}
