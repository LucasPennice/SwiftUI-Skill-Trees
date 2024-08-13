//
//  TreeNode.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData

@Model
final class TreeNode {
//    let id = UUID()

//    var layer: Int

//    var coordinates: CGPoint

//    @Relationship(deleteRule: .cascade, inverse: \TreeNode.parent)
//    var successors: [TreeNode]
//    var parent: TreeNode?
//    var additionalParents: [TreeNode]
    var progressTree: ProgressTree?

    ///
    /// Data Related Attributes
    ///
    private(set) var complete: Bool
    var name: String
    var emojiIcon: String

    ///
    /// Progress Tree Related Attributes
    ///
    private(set) var progressiveQuest: Bool = false
    var unit: String = ""
    var amount: Double = 0.0
    @Relationship(deleteRule: .cascade, inverse: \ItemCompletionRecord.treeNode)
    private(set) var completionHistory: [ItemCompletionRecord] = []
    ///

    func enableProgressiveQuest() { progressiveQuest = true }

    var items: [NodeListItem] = []

    func undoCompletion(_ date: Date = .now) {
        //
    }

    func calculateProgress(forDate: Date = .now) -> Double {
        /// Returns progress percentage (range of 0.0 to 1.0)
        ///
        if items.isEmpty { return 0.0 }

        let quantity = items.count

        let completed = items.reduce(0, { accumulator, value in
            if value.complete { return accumulator + 1 }

            return accumulator
        })

        let progress = Double(completed) / Double(quantity)

        let progressRounded3Decimals = Double(round(1000 * progress) / 1000)

        return progressRounded3Decimals
    }

    func addItem(_ newItem: NodeListItem) {
        items.append(newItem)
    }

//    func getSuccessorsContour() -> LevelContour? {
//        if successors.isEmpty { return nil }
//
//        var leftNode = successors.first!
//        var rightNode = successors.first!
//
//        for node in successors {
//            if node.coordinates.x < leftNode.coordinates.x {
//                leftNode = node
//            }
//
//            if node.coordinates.x > rightNode.coordinates.x {
//                rightNode = node
//            }
//        }
//
//        return LevelContour(leftNode: leftNode, rightNode: rightNode)
//    }

    init(progressTree: ProgressTree? = nil, unit: String, amount: Double, complete: Bool, progressiveQuest: Bool, name: String, emojiIcon: String, items: [NodeListItem], completionHistory: [ItemCompletionRecord]) {
        self.progressTree = progressTree
        self.unit = unit
        self.amount = amount
        self.complete = complete
        self.progressiveQuest = progressiveQuest
        self.name = name
        self.items = items
        self.completionHistory = completionHistory
        self.emojiIcon = emojiIcon
//        layer = -1
//        coordinates = CGPoint(x: 0.0, y: 0.0)
//        successors = []
//        parent = nil
//        additionalParents = []
    }
}

struct NodeListItem: Codable, Hashable {
    var name: String
    var complete: Bool
}
