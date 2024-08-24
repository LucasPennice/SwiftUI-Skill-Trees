//
//  NewMilestoneSheetVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 21/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

extension NewMilestoneSheetView {
    @Observable
    class ViewModel {
        ///
        /// Data
        ///
        var insertNodePosition: InsertNodePosition
        var addTreeNode: (TreeNode, PersistentIdentifier) -> Void
        ///
        /// UI State
        ///
        var showingEmojiPicker: Bool = false
        var selectedCompletionType: TreeNodeType = .Repeat { didSet { resetNodeTypeInputState() }}
        ///
        /// New Node State
        ///
        var color: Color
        var emojiIcon: String = "😄"
        var name: String = ""
        /// Progressive
        var unitInteger: Int = 0
        var repeatTimesToComplete: Int = 0
        var unitDecimal: Double = .zero
        var unit: String = ""
        var items: [NodeListItem] = []

        func resetNodeTypeInputState() {
            unitInteger = 0
            repeatTimesToComplete = 0
            unitDecimal = .zero
            unit = ""
            items = []
        }

        var addDisabled: Bool {
            if name.isEmpty { return true }

            if selectedCompletionType == .List {
                return items.isEmpty
            } else if selectedCompletionType == .Progressive {
                return unit.isEmpty
            }

            return false
        }

        func addNodeAndClose(dismiss: DismissAction) {
            let newNode = TreeNode(
                unit: unit,
                amount: 0,
                complete: false,
                progressiveQuest: selectedCompletionType == .Progressive ? true : false,
                name: name,
                emojiIcon: emojiIcon,
                items: items,
                completionHistory: []
            )

            newNode.orderKey = insertNodePosition.orderKey
            newNode.targetAmount = Double(unitInteger) + unitDecimal
            newNode.repeatTimesToComplete = repeatTimesToComplete

            addTreeNode(newNode, insertNodePosition.parentId)

            dismiss()
        }

        init(addTreeNode: @escaping (TreeNode, PersistentIdentifier) -> Void, insertNodePosition: InsertNodePosition, treeColor: Color) {
            self.addTreeNode = addTreeNode
            self.insertNodePosition = insertNodePosition
            color = treeColor
        }
    }
}
