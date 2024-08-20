//
//  CompleteListNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftData
import SwiftUI

struct CompleteListNodeView: View {
    var node: TreeNode

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(node.items.enumerated()), id: \.offset) { idx, item in
                HStack {
                    VStack {
                        if item.complete {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.system(size: 22))
                                .frame(width: 40, height: 40)
                                .background(AppColors.darkGray)
                                .cornerRadius(6)
                                .transition(.blurReplace)
                        } else {
                            DrawCheckmarkView(runOnFingerLifted: { withAnimation { node.items[idx].complete = true } })
                                .transition(.scale(scale: 0.3, anchor: .center))
                        }
                    }
                    .frame(width: 80)

                    Text(item.name)
                    Spacer()
                }
                .frame(height: 80)

                if item != node.items.last! {
                    Divider()
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .clipped()
        .background(AppColors.midGray)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ProgressTree.self, configurations: config)

    let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .blue)

    let rootNode = TreeNode(name: "Root", emojiIcon: "👨🏻‍🍳")
    rootNode.orderKey = 1
    container.mainContext.insert(rootNode)
    rootNode.progressTree = tree
    tree.treeNodes.append(rootNode)
    try? container.mainContext.save()

    let childNode1 = TreeNode(name: "LEVEL 1", emojiIcon: "👨🏻‍🍳")
    childNode1.orderKey = 2
    container.mainContext.insert(childNode1)
    childNode1.progressTree = tree
    childNode1.parent = rootNode
    rootNode.successors.append(childNode1)
    tree.treeNodes.append(childNode1)
    childNode1.items = [NodeListItem(name: "Get to work", complete: true), NodeListItem(name: "Quit work", complete: false)]

    let mockCompletionHistoryItem: [ItemCompletionRecord] = [
        ItemCompletionRecord(date: .now.dateInDays(-30), unit: "Kgs", amount: 20, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-25), unit: "Kgs", amount: 25, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-20), unit: "Kgs", amount: 30, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-15), unit: "Kgs", amount: 35, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-10), unit: "Kgs", amount: 40, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-5), unit: "Kgs", amount: 50, treeNode: childNode1),
    ]

    childNode1.completionHistory = mockCompletionHistoryItem

    return CompleteListNodeView(node: childNode1)
}
