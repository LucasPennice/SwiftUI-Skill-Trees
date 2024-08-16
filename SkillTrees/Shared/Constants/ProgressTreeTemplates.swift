//
//  ProgressTreeTemplates.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 12/08/2024.
//
import Foundation

struct ProgressTreeTemplates {
    static var cookingTree: ProgressTree {
        let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .blue)

        return tree
    }
    
    static var trees: [ProgressTree] =
        [
            cookingTree,
        ]
}
