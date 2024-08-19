//
//  TreeNodeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import SwiftData
import SwiftUI

struct RootNodeShape: Shape {
    var rectSize: Double

    let rotationInRadians = 45 * Double.pi / 180
    var tX: Double { -rectSize / 2 }
    var tY: Double { -rectSize / 2 }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: CGRect(origin: CGPoint(x: rect.midX + tX, y: rect.midY + tY), size: CGSize(width: rectSize, height: rectSize)),
            cornerSize: CGSize(width: 10, height: 10))

        return path
    }

    var animatableData: Double {
        get { rectSize }
        set { rectSize = newValue }
    }
}

struct RootNodeProgressShape: Shape {
    var rectSize: Double
    var progress: Double

    let rotationInRadians = 45 * Double.pi / 180
    var tX: Double { -rectSize / 2 }
    var tY: Double { -rectSize / 2 }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: CGRect(origin: CGPoint(x: rect.midX + tX, y: rect.midY + tY), size: CGSize(width: rectSize, height: rectSize)),
            cornerSize: CGSize(width: 10, height: 10))

        return path.trimmedPath(from: 0, to: progress)
    }

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(rectSize, progress) }
        set {
            rectSize = newValue.first
            progress = newValue.second
        }
    }
}

struct NodeProgressShape: Shape {
    var progress: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addEllipse(in: rect)

        return path.trimmedPath(from: 0, to: progress)
    }

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}

struct NodeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addEllipse(in: rect)

        return path
    }
}

struct TreeNodeView: View {
    static let defaultSize = 45.0
    static let defaultIcon = "😄"
    static let defaultColor = Color.green

    let node: TreeNode

    var selected: Bool

    var regularNodeSize: Double {
        if selected {
            return 2 * TreeNodeView.defaultSize
        } else {
            return TreeNodeView.defaultSize
        }
    }

    var rootNodeSize: Double {
        if selected {
            return 85
        } else {
            return 55
        }
    }

    var showNodeType: Bool {
        /// Complete nodes don't show a badge
        if node.complete == true { return false }
        /// Root nodes don't show a badge
        if node.parent == nil { return false }
        /// Incomplete progress nodes show a badge
        if node.progressiveQuest == true { return true }
        /// Incomplete list nodes show a badge
        if !node.items.isEmpty { return true }
        /// Repeatable nodes where repeat time is greater than 1 show a badge
        if node.repeatTimesToComplete > 1 { return true }

        return false
    }

    var nodeTypeIcon: String {
        if node.progressiveQuest == true { return "chart.line.uptrend.xyaxis.circle.fill" }

        if !node.items.isEmpty { return "list.bullet.circle.fill" }

        return "repeat.circle.fill"
    }

    @ViewBuilder var body: some View {
        ZStack {
            if node.parent == nil {
                RootNodeShape(rectSize: rootNodeSize)
                    .fill(.black)
                    .stroke(AppColors.midGray, style: StrokeStyle(lineWidth: regularNodeSize * 0.07))
                    .frame(width: rootNodeSize, height: rootNodeSize)
                    .rotationEffect(.init(degrees: 45))

                RootNodeProgressShape(rectSize: rootNodeSize, progress: node.calculateProgress())
                    .stroke(node.color, style: StrokeStyle(lineWidth: regularNodeSize * 0.07, lineCap: .round))
                    .frame(width: rootNodeSize, height: rootNodeSize)
                    .rotationEffect(.init(degrees: 45))

            } else {
                NodeShape()
                    .fill(.black)
                    .stroke(AppColors.midGray, style: StrokeStyle(lineWidth: regularNodeSize * 0.05))
                    .frame(width: regularNodeSize, height: regularNodeSize)

                NodeProgressShape(progress: node.calculateProgress())
                    .stroke(node.color, style: StrokeStyle(lineWidth: regularNodeSize * 0.05, lineCap: .round))
                    .frame(width: regularNodeSize, height: regularNodeSize)
                    .rotationEffect(.init(degrees: 70))
            }

            Text(node.emojiIcon)
                .foregroundStyle(.white)
                .font(.system(size: regularNodeSize * 0.55))

            if showNodeType {
                Image(systemName: nodeTypeIcon)
                    .foregroundStyle(node.color)
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: regularNodeSize * 0.35))
                    .offset(x: regularNodeSize / 2 - (regularNodeSize * 0.1), y: regularNodeSize / 2 - (regularNodeSize * 0.1))
            }
        }
        .padding(1)
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
    childNode1.repeatTimesToComplete = 3
    container.mainContext.insert(childNode1)
    childNode1.progressTree = tree
    childNode1.parent = rootNode
    rootNode.successors.append(childNode1)
    tree.treeNodes.append(childNode1)

    let childNode12 = TreeNode(name: "LEVEL 1.2", emojiIcon: "👨🏻‍🍳")
    childNode12.orderKey = 3
    container.mainContext.insert(childNode12)
    childNode12.progressTree = tree
    childNode12.parent = rootNode
    rootNode.successors.append(childNode12)
    tree.treeNodes.append(childNode12)

    return TreeNodeView(node: rootNode, selected: false)
        .modelContainer(container)
}
