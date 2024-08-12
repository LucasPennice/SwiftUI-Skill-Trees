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
    var progressTree: ProgressTree?

    var unit: String = ""
    var amount: Double = 0.0
    private(set) var complete: Bool

    private(set) var progressiveQuest: Bool = false

    func enableProgressiveQuest() { progressiveQuest = true }

    var name: String

    var lastComplete: Date?

    var items: [NodeListItem] = []

    @Relationship(deleteRule: .cascade, inverse: \ItemCompletionRecord.treeNode)
    private(set) var completionHistory: [ItemCompletionRecord] = []

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

    init(progressTree: ProgressTree? = nil, unit: String, amount: Double, complete: Bool, progressiveQuest: Bool, name: String, lastComplete: Date? = nil, items: [NodeListItem], completionHistory: [ItemCompletionRecord]) {
        self.progressTree = progressTree
        self.unit = unit
        self.amount = amount
        self.complete = complete
        self.progressiveQuest = progressiveQuest
        self.name = name
        self.lastComplete = lastComplete
        self.items = items
        self.completionHistory = completionHistory
    }
}

struct NodeListItem: Codable, Hashable {
    var name: String
    var complete: Bool
}
