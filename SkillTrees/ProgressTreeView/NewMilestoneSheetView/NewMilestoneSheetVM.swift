//
//  NewMilestoneSheetVM.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 21/08/2024.
//

import Foundation
import SwiftUI

extension NewMilestoneSheetView {
    @Observable
    class ViewModel {
        ///
        /// Data
        ///
        var insertNodePosition: InsertNodePosition
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
            if selectedCompletionType == .List {
                return items.isEmpty
            } else if selectedCompletionType == .Progressive {
                return unit.isEmpty
            }

            return false
        }

        func addMilestone() {
        }

        init(insertNodePosition: InsertNodePosition, treeColor: Color) {
            self.insertNodePosition = insertNodePosition
            color = treeColor
        }
    }
}
