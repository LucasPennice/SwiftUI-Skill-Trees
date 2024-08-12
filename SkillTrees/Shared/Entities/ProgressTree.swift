//
//  ProgressTree.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData

@Model
final class ProgressTree {
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \TreeNode.progressTree)
    var treeNodes: [TreeNode]

    init(name: String, treeNodes: [TreeNode]) {
        self.name = name
        self.treeNodes = treeNodes
    }
}

