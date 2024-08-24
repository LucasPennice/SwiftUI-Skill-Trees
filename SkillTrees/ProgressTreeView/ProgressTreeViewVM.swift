//
//  ProgressTreeVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

extension ProgressTreeView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        /// Data State
        var progressTree = ProgressTree(name: "Loading", emojiIcon: "⏳", color: .accentColor)
        private var progressTreeId: PersistentIdentifier
        var insertNodePositions: [InsertNodePosition] = []
        /// New node related
        /// Only needed because we call the add node function once the new node sheet closes, loosing it's internal state
        var tempNewNode: TreeNode?
        var tempNewNodeParentId: PersistentIdentifier?
        /// UI State
        var selectedNode: TreeNode?
        var canvasSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        private(set) var showingInsertNodePositions = false
        var selectedInsertNodePosition: InsertNodePosition?

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

                withAnimation {
                    canvasSize = updatedCanvasSize
                }

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

        func showInsertNodePositions() {
            showingInsertNodePositions = true

            insertNodePositions = InsertNodePosition.getTreeInsertPositions(treeNodes: progressTree.treeNodes)
        }

        func tapInsertNodePosition(_ insertNodePosition: InsertNodePosition) {
            selectedInsertNodePosition = insertNodePosition
        }

        func hideInsertNodePositions() {
            showingInsertNodePositions = false
        }

        func updateNewNodeTempValues(newNode: TreeNode, parentNodeId: PersistentIdentifier) {
            tempNewNode = newNode
            tempNewNodeParentId = parentNodeId
            showingInsertNodePositions = false
            selectedInsertNodePosition = nil
        }

        func addTreeNode() {
            if let newNode = tempNewNode {
                if let parentNodeId = tempNewNodeParentId {
                    if let parentNode = modelContext.model(for: parentNodeId) as? TreeNode {
                        newNode.coordinates = parentNode.coordinates

                        modelContext.insert(newNode)

                        newNode.progressTree = progressTree
                        newNode.parent = parentNode

                        parentNode.successors.append(newNode)

                        progressTree.treeNodes.append(newNode)

                        tempNewNode = nil
                        tempNewNodeParentId = nil

                        fetchData()
                    }
                }
            }
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
