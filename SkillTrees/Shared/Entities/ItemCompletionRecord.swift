//
//  ItemCompletionRecord.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData

@Model
final class ItemCompletionRecord {
    var date: Date
    var unit: String
    var amount: Double
    var treeNode: TreeNode?

    init(date: Date, unit: String, amount: Double, treeNode: TreeNode) {
        self.date = date
        self.unit = unit
        self.treeNode = treeNode
        self.amount = amount
    }
}
