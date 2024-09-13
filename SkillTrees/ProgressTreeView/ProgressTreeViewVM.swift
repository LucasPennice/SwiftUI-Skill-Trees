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
    final class ViewModel {
        var modelContext: ModelContext
        var scrollViewProxy: ScrollViewProxy?
        ///
        /// Data State
        ///
        @MainActor var progressTree = ProgressTree(name: "Loading", emojiIcon: "⏳", color: .accentColor)
        private var progressTreeId: PersistentIdentifier
        @MainActor var insertNodePositions: [InsertNodePosition] = []
        ///
        /// New node related
        /// Only needed because we call the add node function once the new node sheet closes, loosing it's internal state
        ///
        var tempNewNode: TreeNode?
        var tempNewNodeParentId: PersistentIdentifier?
        ///
        /// UI State
        ///
        @MainActor var selectedNode: TreeNode?
        @MainActor var canvasSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        @MainActor private(set) var showingInsertNodePositions = false
        @MainActor var selectedInsertNodePosition: InsertNodePosition?
        @MainActor private(set) var showingConnectingMode = false
        ///
        /// Connecting milestone state
        ///
        @MainActor var connectingMilestoneChild: TreeNode?
        @MainActor var connectingMilestoneParent: TreeNode?

        let lowOpacity = 0.4

        init(modelContext: ModelContext, progressTreeId: PersistentIdentifier) {
            self.modelContext = modelContext

            self.progressTreeId = progressTreeId
        }

        @MainActor
        func fetchData(skipUpdateCoordinates: Bool? = nil) {
            do {
                let fetchProgressTreePredicate = #Predicate<ProgressTree> { tree in tree.persistentModelID == progressTreeId }

                let fetchProgressTreeDescriptor = FetchDescriptor<ProgressTree>(predicate: fetchProgressTreePredicate)

                progressTree = try modelContext.fetch(fetchProgressTreeDescriptor)[0]

                if skipUpdateCoordinates != true {
                    let updatedCanvasSize = progressTree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                    withAnimation { canvasSize = updatedCanvasSize }
                } else {
                    withAnimation {
                        canvasSize = CanvasDimensions.getCanvasDimensions(
                            screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                            treeNodes: progressTree.treeNodes
                        )
                    }
                }

            } catch {
                print("Fetch failed")
            }
        }

        @MainActor
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

        @MainActor
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

        @MainActor
        func showInsertNodePositions() {
            showingInsertNodePositions = true

            insertNodePositions = InsertNodePosition.getTreeInsertPositions(treeNodes: progressTree.treeNodes)
        }

        @MainActor
        func tapInsertNodePosition(_ insertNodePosition: InsertNodePosition) {
            selectedInsertNodePosition = insertNodePosition
        }

        @MainActor
        func hideInsertNodePositions() {
            showingInsertNodePositions = false
        }

        @MainActor
        func updateNewNodeTempValues(newNode: TreeNode, parentNodeId: PersistentIdentifier) {
            tempNewNode = newNode
            tempNewNodeParentId = parentNodeId
            showingInsertNodePositions = false
            selectedInsertNodePosition = nil
        }

        @MainActor
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

                        try? modelContext.save()

                        #warning("siguen siendo lentas las updates. deberia testear correr la funcion de fetchear en otro hilo")
                        #warning("como cuando hago lo de meter las templates. eso me parece que es un cuello de botella bastante")
                        #warning("grande")
                        
                        fetchData()
                    }
                }
            }
        }

        @MainActor
        func showConnectingMode(_ selectedNode: TreeNode) {
            connectingMilestoneChild = selectedNode
            showingConnectingMode = true
        }

        ///
        /// Node Related Functions
        ///
        @MainActor
        func tapNode(_ node: TreeNode) {
            if showingConnectingMode && connectingMilestoneChild != nil {
                if node.layer >= connectingMilestoneChild!.layer
                    || connectingMilestoneChild!.parent!.persistentModelID == node.persistentModelID
                    || connectingMilestoneChild!.additionalParents.contains(where: { $0.persistentModelID == node.persistentModelID }) { return }

                return selectConnectMilestoneParent(node)
            }

            if node.parent != nil { return selectNode(node) }
        }

        @MainActor
        func nodeOpacity(_ node: TreeNode) -> Double {
            if showingInsertNodePositions == true { return 0.7 }

            if showingConnectingMode == true {
                if node.persistentModelID == connectingMilestoneChild!.persistentModelID { return 1 }

                if node.layer >= connectingMilestoneChild!.layer
                    || connectingMilestoneChild!.parent!.persistentModelID == node.persistentModelID
                    || connectingMilestoneChild!.additionalParents.contains(where: { $0.persistentModelID == node.persistentModelID }) { return 0.2 }

                return 1
            }

            return 1
        }

        @MainActor
        func nodeScale(_ node: TreeNode) -> Double {
            if showingConnectingMode == true {
                if node.persistentModelID == connectingMilestoneChild!.persistentModelID
                    || node.persistentModelID == connectingMilestoneParent?.persistentModelID {
                    return 1.5
                } else {
                    return 1
                }
            }

            return 1
        }

        @MainActor
        func selectNode(_ node: TreeNode) {
            if selectedNode != nil && selectedNode!.persistentModelID == node.persistentModelID {
                selectedNode = nil
            } else {
                selectedNode = node
            }
        }

        @MainActor
        func selectConnectMilestoneParent(_ node: TreeNode) {
            if node.persistentModelID == connectingMilestoneChild?.persistentModelID { return }

            connectingMilestoneParent = node
        }

        ///
        /// Opacity, Scaling Related Functions
        ///

        @MainActor
        func labelOpacity(_ node: TreeNode) -> Double {
            if showingInsertNodePositions == true { return .zero }

            if showingConnectingMode == true {
                if node.persistentModelID == connectingMilestoneChild?.persistentModelID
                    || node.persistentModelID == connectingMilestoneParent?.persistentModelID {
                    return 1
                } else {
                    return lowOpacity
                }
            }

            return 1
        }

        @MainActor
        func edgeOpacity(_ node: TreeNode) -> Double {
            if showingInsertNodePositions == true { return lowOpacity }

            if showingConnectingMode == true { return lowOpacity }

            return 1
        }

        ///
        /// Top Leading Button Related Functions
        ///
        @MainActor
        func cancelConnectAdditionalMilestone() {
            showingConnectingMode = false
            connectingMilestoneChild = nil
            connectingMilestoneParent = nil
        }

        @MainActor
        func topLeadingButtonDimensions() -> CGSize {
            if showingInsertNodePositions { return CGSize(width: 80, height: 30) }

            if showingConnectingMode { return CGSize(width: 80, height: 30) }

            return CGSize(width: 30, height: 30)
        }

        ///
        /// Top Trailing Button Related Functions
        ///
        @MainActor
        func topTrailingButtonDimensions() -> CGSize {
            if showingInsertNodePositions { return CGSize(width: 190, height: 50) }

            if showingConnectingMode { return CGSize(width: 90, height: 30) }

            return CGSize(width: 30, height: 30)
        }

        @MainActor
        func disableTopTrailingButton() -> Bool {
            if showingInsertNodePositions { return true }

            if showingConnectingMode && (connectingMilestoneChild == nil || connectingMilestoneParent == nil) { return true }

            return false
        }

        @MainActor
        func topTrailingButtonOpacity() -> Double {
            if selectedNode != nil { return 0 }

            if showingInsertNodePositions { return 1 }

            if disableTopTrailingButton() == true { return 0.4 }

            return 1
        }

        @MainActor
        func connectAdditionalMilestone() {
            if let node = connectingMilestoneChild {
                if let additionalParent = connectingMilestoneParent {
                    node.additionalParents.append(additionalParent)

                    showingConnectingMode = false
                    connectingMilestoneChild = nil
                    connectingMilestoneParent = nil
                }
            }
        }
    }
}
