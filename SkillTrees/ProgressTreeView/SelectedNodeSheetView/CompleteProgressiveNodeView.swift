//
//  CompleteProgressiveNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftData
import SwiftUI

struct CompleteProgressiveNodeView: View {
    var node: TreeNode

    @EnvironmentObject var surveySheetHandler: SurveySheetHandler

    @State private var unitInteger: Int
    @State private var unitDecimal: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !node.complete {
                HStack {
                    HStack(spacing: 0) {
                        Picker(selection: $unitInteger, label: Text("Picker")) {
                            ForEach(stride(from: 0, to: 500, by: 1).map({ $0 }), id: \.self) { number in
                                Text("\(number)")
                                    .tag(number)
                            }
                        }
                        .pickerStyle(.wheel)
                        .clipShape(.rect.offset(x: -32))
                        .padding(.trailing, -32)
                        .frame(width: 100)

                        Picker(selection: $unitDecimal, label: Text("Picker")) {
                            ForEach(stride(from: 0, to: 1, by: 0.25).map({ $0 }), id: \.self) { number in
                                Text("\(String(number))")
                                    .tag(number)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                        .clipShape(.rect.offset(x: 16))
                        .padding(.leading, -16)
                    }
                    .background(AppColors.darkGray)
                    .frame(height: 100)
                    .cornerRadius(13)
                    .shadow(color: .black.opacity(0.5), radius: 5)

                    Spacer()

                    DrawCheckmarkView(runOnFingerLifted: {
                        node.amount = Double(unitInteger) + unitDecimal

                        withAnimation {
                            node.progressMilestone()
                        }

                        surveySheetHandler.runOnProgressMilestone()
                    })
                }

                Text("Target is:  \(String(node.targetAmount)) \(node.unit)")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textGray)
            }

            if !node.completionHistory.isEmpty {
                ChartView(completionHistory: node.completionHistory, targetAmount: node.targetAmount)

                let lastEntry = node.completionHistory.max(by: { $0.date < $1.date })!

                Text("Last Entry: \(String(lastEntry.amount)) \(lastEntry.unit) at \(lastEntry.date.formatted(date: .long, time: .omitted))")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textGray)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .clipped()
        .background(AppColors.midGray)
    }

    init(node: TreeNode) {
        self.node = node
        _unitInteger = State(initialValue: Int(node.amount))
        _unitDecimal = State(initialValue: node.amount - Double(Int(node.amount)))
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
    childNode1.unit = "kgs"
    childNode1.targetAmount = 90.25

    let mockCompletionHistoryItem: [ItemCompletionRecord] = [
        ItemCompletionRecord(date: .now.dateInDays(-30), unit: "Kgs", amount: 20, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-25), unit: "Kgs", amount: 25, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-20), unit: "Kgs", amount: 30, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-15), unit: "Kgs", amount: 35, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-10), unit: "Kgs", amount: 40, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-5), unit: "Kgs", amount: 50, treeNode: childNode1),
    ]

    childNode1.completionHistory = mockCompletionHistoryItem

    return CompleteProgressiveNodeView(node: childNode1)
}
