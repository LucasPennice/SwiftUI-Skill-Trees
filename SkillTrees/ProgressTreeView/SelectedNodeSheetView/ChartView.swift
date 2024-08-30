//
//  ChartView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import Charts
import SwiftData
import SwiftUI

struct ChartView: View {
    var completionHistory: [ItemCompletionRecord]

    var largestValue: Double {
        let maxValue = completionHistory.max { a, b in a.amount < b.amount }

        if let maxValue { return maxValue.amount }

        return .zero
    }

    var earliestValue: Date {
        if let minValue = completionHistory.min(by: { $0.date < $1.date }) {
            return minValue.date
        }

        return .now
    }

    var latestValue: Date {
        if let maxValue = completionHistory.max(by: { $0.date < $1.date }) {
            return maxValue.date
        }

        return .now
    }

    let tomorrow = Date.now.dateInDays(1)

    var color: Color { return completionHistory.first!.treeNode!.color }

    var targetAmount: Double

    var body: some View {
        Chart {
            ForEach(completionHistory.sorted(by: { $0.date < $1.date })) { element in
                PointMark(
                    x: .value("Day", element.date, unit: .day),
                    y: .value(element.unit, element.amount)
                )
                .symbolSize(40.0)
                .foregroundStyle(color)

                LineMark(
                    x: .value("Day", element.date, unit: .day),
                    y: .value(element.unit, element.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(color)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))

                RuleMark(
                    xStart: .value("Start Date", earliestValue),
                    xEnd: .value("End Date", .now),
                    y: .value("Current", targetAmount)
                )
                .foregroundStyle(AppColors.textGray)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [7]))
            }
        }
        .chartXAxis { AxisMarks(values: .automatic) {
            AxisValueLabel()
                .foregroundStyle(AppColors.textGray) // <= change the style of the label
            AxisGridLine()
                .foregroundStyle(AppColors.textGray.opacity(0.2)) // <= change the style of the line
        }
        }
        .chartYAxis { AxisMarks(values: .automatic) {
            AxisValueLabel()
                .foregroundStyle(AppColors.textGray) // <= change the style of the label
            AxisGridLine()
                .foregroundStyle(AppColors.textGray.opacity(0.2)) // <= change the style of the line
        }
        }
        .chartLegend(.hidden)
        .animation(.default, value: completionHistory)
        .frame(height: 150)
        .padding(.vertical)
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

    let mockCompletionHistoryItem: [ItemCompletionRecord] = [
        ItemCompletionRecord(date: .now.dateInDays(-30), unit: "Kgs", amount: 20, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-25), unit: "Kgs", amount: 25, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-20), unit: "Kgs", amount: 30, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-15), unit: "Kgs", amount: 35, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-10), unit: "Kgs", amount: 40, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-5), unit: "Kgs", amount: 50, treeNode: childNode1),
        ItemCompletionRecord(date: .now, unit: "Kgs", amount: 55, treeNode: childNode1),
    ]

    return ChartView(completionHistory: mockCompletionHistoryItem, targetAmount: 100.0)
}
