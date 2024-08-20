//
//  CompleteDefaultTreeNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import SwiftData
import SwiftUI

struct CompleteDefaultNodeView: View {
    @State private var points: [CGPoint] = []
    @State private var showPath: Bool = false

    var node: TreeNode

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(AppColors.darkGray)
                .edgesIgnoringSafeArea(.all)
                .highPriorityGesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        if showPath == false { withAnimation { showPath = true }}

                        self.addNewPoint(value)
                    })
                    .onEnded({ _ in
                        node.progressMilestone()

                        withAnimation { showPath = false }

                        points = []
                    }))

            VStack {
                Image(systemName: "hand.draw")
                    .font(.system(size: 30))
                    .foregroundColor(.gray.opacity(0.2))

                Text("Draw a checkmark to complete")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.2))
            }
            .allowsHitTesting(false)

            if showPath {
                DrawShape(points: points)
                    .stroke(lineWidth: 5)
                    .foregroundColor(.green)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity.combined(with: .scale(scale: 0))))
                    .zIndex(2)
            }
        }
        .clipped()
        .sensoryFeedback(.success, trigger: points.isEmpty, condition: { old, new in
            old == true && new == false
        })
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 105)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.midGray, lineWidth: 3)
        )
        .background(.clear)
    }

    private func addNewPoint(_ value: DragGesture.Value) {
        // here you can make some calculations based on previous points
        points.append(value.location)
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

    let mockCompletionHistoryItem: [ItemCompletionRecord] = [
        ItemCompletionRecord(date: .now.dateInDays(-30), unit: "Kgs", amount: 20, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-25), unit: "Kgs", amount: 25, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-20), unit: "Kgs", amount: 30, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-15), unit: "Kgs", amount: 35, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-10), unit: "Kgs", amount: 40, treeNode: childNode1),
        ItemCompletionRecord(date: .now.dateInDays(-5), unit: "Kgs", amount: 50, treeNode: childNode1),
    ]

    childNode1.completionHistory = mockCompletionHistoryItem

    return CompleteDefaultNodeView(node: childNode1)
}
