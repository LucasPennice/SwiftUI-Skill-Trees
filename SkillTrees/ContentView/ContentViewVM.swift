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
        var editingProgressTree: ProgressTree?
        var path = NavigationPath()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<ProgressTree>(sortBy: [SortDescriptor(\ProgressTree.orderKey, order: .reverse)])
                progressTrees = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }

        func countCompleteOrProgressedNodes() -> Int {
            let descriptor = FetchDescriptor<ItemCompletionRecord>()
            let completeOrProgressedNodes = (try? modelContext.fetchCount(descriptor)) ?? 0

            return completeOrProgressedNodes
        }

        func addProgressTree(_ tree: ProgressTree) {
            modelContext.insert(tree)

            let rootNode = TreeNode(progressTree: tree, unit: "", amount: 0.0, complete: false, progressiveQuest: false, name: tree.name, emojiIcon: tree.emojiIcon, items: [], completionHistory: [])

            tree.treeNodes.append(rootNode)

            fetchData()
        }

        func addTemplateTree(_ templateId: String) {
            ProgressTreeTemplates.addTemplate(templateId, modelContext: modelContext)

            fetchData()
        }

        func saveProgressTreeEdit(_ tree: ProgressTree) {
            let rootNode = tree.treeNodes.first(where: { $0.parent == nil })

            for node in tree.treeNodes { node.updateColor(tree.color) }

            if let rootNode = rootNode {
                rootNode.emojiIcon = tree.emojiIcon
                rootNode.name = tree.name

                fetchData()
            }
        }

        func deleteTree(tree: ProgressTree) {
            modelContext.delete(tree)

            fetchData()
        }
    }
}
