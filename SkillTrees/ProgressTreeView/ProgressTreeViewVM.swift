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
        var progressTree: ProgressTree
        var treeNodes = [TreeNode]()
        var canvasSize: CGSize

        init(modelContext: ModelContext, progressTree: ProgressTree) {
            self.modelContext = modelContext
            self.progressTree = progressTree
            canvasSize = CanvasDimensions.getCanvasDimensions(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), treeNodes: progressTree.treeNodes)

            fetchData()
        }

        #warning("ok mas o menos anda esto, mi pregunta es, si lo que yo fetcheo a mano es el arbol de nuevo, andara mejor esto?")
        
        func fetchData() {
            do {
                let id = progressTree.persistentModelID

                let predicate = #Predicate<TreeNode> { node in node.progressTree?.persistentModelID == id }

                let descriptor = FetchDescriptor<TreeNode>(predicate: predicate)

                treeNodes = try modelContext.fetch(descriptor)
                
                progressTree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                canvasSize = CanvasDimensions.getCanvasDimensions(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), treeNodes: treeNodes)

            } catch {
                print("Fetch failed")
            }
        }

        func deleteNode(_ node: TreeNode) {
            modelContext.delete(node)

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
            let newNode = TreeNode(name: "newNode", emojiIcon: "👨🏻‍🍳")
            modelContext.insert(newNode)

            newNode.progressTree = progressTree
            newNode.parent = parentNode

            parentNode.successors.append(newNode)

            progressTree.treeNodes.append(newNode)

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
