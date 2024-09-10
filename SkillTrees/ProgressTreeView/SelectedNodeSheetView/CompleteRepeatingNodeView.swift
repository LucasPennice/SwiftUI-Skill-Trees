//
//  CompleteRepeatingNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftData
import SwiftUI

struct CompleteRepeatingNodeView: View {
    @EnvironmentObject var surveySheetHandler: SurveySheetHandler
    var node: TreeNode

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !node.complete {
                HStack {
                    Text("\(node.repeatTimesToComplete - node.completionHistory.count)")
                        .font(.system(size: 52))
                        .contentTransition(.numericText())
                        .shadow(color: .black.opacity(1), radius: 5)

                    Spacer()

                    DrawCheckmarkView(runOnFingerLifted: {
                        withAnimation { node.progressMilestone() }

                        surveySheetHandler.runOnProgressMilestone()

                    })
                }

                Divider()
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
                ForEach(1 ... node.repeatTimesToComplete, id: \.self) { idx in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(idx > node.completionHistory.count ? AppColors.darkGray : .green)
                        .frame(width: 20, height: 10)
                }
            }
        }
        .padding()
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
    childNode1.amount = 60.25
    childNode1.targetAmount = 90.25
    childNode1.repeatTimesToComplete = 30

    let mockCompletionHistoryItem: [ItemCompletionRecord] = [
        ItemCompletionRecord(date: .now.dateInDays(-30), unit: "Kgs", amount: 20, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-25), unit: "Kgs", amount: 25, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-20), unit: "Kgs", amount: 30, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-15), unit: "Kgs", amount: 35, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-10), unit: "Kgs", amount: 40, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-5), unit: "Kgs", amount: 50, treeNode: childNode1),
    ]

    childNode1.completionHistory = mockCompletionHistoryItem

    return CompleteRepeatingNodeView(node: childNode1)
}
