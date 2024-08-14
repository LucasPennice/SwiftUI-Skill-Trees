//
//  ProgressTreeVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import Foundation
import SwiftData

extension ProgressTreeView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var progressTree: ProgressTree
        var treeNodes = [TreeNode]()

        init(modelContext: ModelContext, progressTree: ProgressTree) {
            self.modelContext = modelContext
            self.progressTree = progressTree
            fetchData()
        }

        func fetchData() {
            do {
                let id = progressTree.persistentModelID

                let predicate = #Predicate<TreeNode> { node in node.progressTree?.persistentModelID == id }

                let descriptor = FetchDescriptor<TreeNode>(predicate: predicate)
//                let descriptor = FetchDescriptor<TreeNode>()

                treeNodes = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }

        func deleteNode(_ node: TreeNode) {
            modelContext.delete(node)

            try? modelContext.save()

            fetchData()
        }

//        func addProgressTree(_ tree: ProgressTree) {
//            modelContext.insert(tree)
//
//            let rootNode = TreeNode(progressTree: tree, unit: "", amount: 0.0, complete: false, progressiveQuest: false, name: tree.name, emojiIcon: tree.emojiIcon, items: [], completionHistory: [])
//
//            tree.treeNodes.append(rootNode)
//
//            fetchData()
//        }
//
//        func deleteTree(tree: ProgressTree) {
//            modelContext.delete(tree)
//
//            fetchData()
//        }
    }
}
