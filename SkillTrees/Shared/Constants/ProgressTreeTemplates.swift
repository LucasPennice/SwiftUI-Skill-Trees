//
//  ProgressTreeTemplates.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 12/08/2024.
//
import Foundation

struct ProgressTreeTemplates {
    static var cookingTree: ProgressTree {
        let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .blue, treeNodes: [
//            TreeNode(unit: "", amount: 0.0, complete: false, progressiveQuest: false, name: "Cooking", lastComplete: nil, items: [], completionHistory: []),
        ]
        )

        return tree
    }
    
    static var trees: [ProgressTree] =
        [
            cookingTree,
        ]
}
