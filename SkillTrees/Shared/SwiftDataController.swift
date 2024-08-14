//
//  SwiftDataController.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([ProgressTree.self])
            let container = try ModelContainer(for: schema, configurations: config)

            let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .blue, treeNodes: [])

            container.mainContext.insert(tree)

            let rootNode = TreeNode(name: "Cooking", emojiIcon: "👨🏻‍🍳", successors: [])

            let childNode1 = TreeNode(name: "level1", emojiIcon: "👨🏻‍🍳", successors: [], parent: rootNode)

            let childNode2 = TreeNode(name: "level2", emojiIcon: "👨🏻‍🍳", successors: [], parent: childNode1)

            tree.treeNodes.append(rootNode)
            tree.treeNodes.append(childNode1)
            tree.treeNodes.append(childNode2)

            rootNode.successors.append(childNode1)
            childNode1.successors.append(childNode2)

            container.mainContext.insert(tree)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
