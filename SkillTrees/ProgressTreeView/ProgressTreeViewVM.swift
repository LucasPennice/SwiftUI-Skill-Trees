//
//  ProgressTreeVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import Foundation
import SwiftData
import UIKit

extension ProgressTreeView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var progressTree = ProgressTree(name: "Loading", emojiIcon: "⏳", color: .accentColor)

        var selectedNode: TreeNode?

        var canvasSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        private var progressTreeId: PersistentIdentifier

        init(modelContext: ModelContext, progressTreeId: PersistentIdentifier) {
            self.modelContext = modelContext

            self.progressTreeId = progressTreeId

            fetchData()
        }

        func fetchData() {
            do {
                let fetchProgressTreePredicate = #Predicate<ProgressTree> { tree in tree.persistentModelID == progressTreeId }

                let fetchProgressTreeDescriptor = FetchDescriptor<ProgressTree>(predicate: fetchProgressTreePredicate)

                progressTree = try modelContext.fetch(fetchProgressTreeDescriptor)[0]

                let updatedCanvasSize = progressTree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                canvasSize = updatedCanvasSize

            } catch {
                print("Fetch failed")
            }
        }

        func deleteNode(_ node: TreeNode) {
            if node.parent == nil { return }

            var nodesToDelete: [TreeNode] = []

            progressTree.appendSubTreeToArray(node, &nodesToDelete)

            for node in nodesToDelete {
                modelContext.delete(node)
            }

            try? modelContext.save()

            fetchData()
        }

        func getLabelVerticalOffset(text: String) -> Double {
            let size = text.sizeOfString()
            let verticalPadding = 7.0
            let maxWidth = 100.0

            if size.width < maxWidth { return size.height }

            let words = text.split(separator: " ")
            var result = ""
            var currentLine = ""

            for word in words {
                let potentialLine = currentLine.isEmpty ? String(word) : "\(currentLine) \(word)"
                let lineWidth = potentialLine.sizeOfString().width

                if lineWidth <= maxWidth {
                    currentLine = potentialLine
                } else {
                    result += currentLine + "\n"
                    currentLine = String(word)
                }
            }

            result += currentLine

            return result.sizeOfString().height / 2 + verticalPadding
        }

        func addTreeNode(parentNode: TreeNode) {
            let newNode = TreeNode(name: "\(Int.random(in: 0 ... 100))", emojiIcon: "👨🏻‍🍳")
            modelContext.insert(newNode)

            newNode.progressTree = progressTree
            newNode.parent = parentNode

            parentNode.successors.append(newNode)

            progressTree.treeNodes.append(newNode)

            fetchData()
        }

        func selectNode(_ node: TreeNode) {
            if selectedNode != nil && selectedNode!.persistentModelID == node.persistentModelID {
                selectedNode = nil
            } else {
                selectedNode = node
            }
        }
    }
}
