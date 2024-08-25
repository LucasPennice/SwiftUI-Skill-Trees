//
//  ProgressTreeCardView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//
import SwiftData
import SwiftUI

struct ProgressTreeCardView: View {
    static let squareCanvasSize: Double = 180

    var tree: ProgressTree
    var scale: Double
    var scaleNodeCoord: (TreeNode) -> CGPoint

    var rootEdgeStartDelta: Double {
        /// This is so the edge will start precisely at the rhombus edge, so when the opacity is != 1 it looks right
        /// First part is the distance from the center to the edge of the rhombus
        /// Second part is the distance from the center to the edge of a regular node
        /// Third part is a corrector factor to be more precise
        return (TreeNodeView.defaultRootNodeSize * scale) / sqrt(2) - (TreeNodeView.defaultSize * scale) / 2 - 2
    }

    var body: some View {
        ZStack(alignment: .leading) {
            ///
            /// Tree Preview
            ///
            HStack {
                Spacer()

                ZStack {
                    ///
                    /// Node Edges
                    ///
                    ForEach(tree.treeNodes) { node in
                        let coordinates = scaleNodeCoord(node)
                        let newNodeSize = (node.parent == nil ? TreeNodeView.defaultRootNodeSize : TreeNodeView.defaultSize) * scale

                        TreeNodeView(node: node, selected: false, size: newNodeSize)
                            .zIndex(2)
                            .position(coordinates)

                        ///
                        /// Successor to Parent Edges
                        ///
                        ForEach(node.successors) { successor in
                            let successorCoord = scaleNodeCoord(successor)

                            EdgeView(
                                startX: coordinates.x,
                                startY: coordinates.y,
                                endX: successorCoord.x,
                                endY: node.parent == nil ? successorCoord.y + rootEdgeStartDelta : successorCoord.y
                            )
                            .stroke(successor.complete ? successor.color : AppColors.midGray, lineWidth: 2)
                        }
                    }
                }
                .frame(width: ProgressTreeCardView.squareCanvasSize, height: ProgressTreeCardView.squareCanvasSize)
                .clipped()
                .drawingGroup()
                .allowsHitTesting(false)
            }

            GeometryReader { proxy in
                VStack {
                    ///
                    /// Card Header
                    ///
                    VStack(spacing: 10) {
                        HStack {
                            Text(tree.emojiIcon)

                            Text(tree.name)
                                .font(.system(size: 20).weight(.medium))

                            Spacer()
                        }

                        ProgressView(value: tree.progress)
                            .scaleEffect(y: 1.2)
                            .tint(tree.color)
                    }

                    Spacer()

                    ///
                    /// Card Footer
                    ///
                    VStack(alignment: .leading, spacing: 5) {
                        /// NEXT MILESTONE (🚨 NOT IMPLEMENTED)
                        Text("Next Milestone")
                            .font(.system(size: 16))

                        HStack {
                            Text(tree.emojiIcon)
                                .font(.system(size: 14))

                            Text("Finish Thesis")
                                .font(.system(size: 16))
                                .opacity(0.8)

                            Spacer()

                            CircularProgressView(strokeColor: tree.color, bgColor: AppColors.midGray, size: 15, progress: 0.24)
                        }
                        .frame(height: 32)
                        .padding(.horizontal, 5)
                        .background(AppColors.darkGray)
                        .cornerRadius(10)
                    }
                }
                .frame(minHeight: 0, maxHeight: .infinity)
                .frame(width: proxy.size.width - 180 * 2 / 3, alignment: .leading)
                .padding()
                .background(Blur(radius: 4))
                .background(AppColors.midGray.opacity(0.55))
                .cornerRadius(10)
            }
        }
        .listRowInsets(EdgeInsets())
        .frame(height: ProgressTreeCardView.squareCanvasSize)
        .background(AppColors.darkGray)
        .cornerRadius(10)
    }

    init(tree: ProgressTree) {
        self.tree = tree

        var minX: Double?
        var maxX: Double?
        var minY: Double?
        var maxY: Double?

        for node in tree.treeNodes {
            if minX == nil || node.coordinates.x < minX! { minX = node.coordinates.x }
            if minY == nil || node.coordinates.y < minY! { minY = node.coordinates.y }

            if maxX == nil || node.coordinates.x > maxX! { maxX = node.coordinates.x }
            if maxY == nil || node.coordinates.y > maxY! { maxY = node.coordinates.y }
        }

        let removeLeftPadding = minX!
        let removeTopPadding = minY!

        let treeWidth = maxX! - minX!
        let treeHeight = maxY! - minY!

        let newPadding = 1.3 * TreeNodeView.defaultRootNodeSize

        ///
        /// Centers node when treeWidth = 0, adds horizontal padding otherwise
        ///
        let xCorrection = treeWidth == 0
            ? ProgressTreeCardView.squareCanvasSize / 2
            : newPadding / 2

        ///
        /// Center root node when treeHeight = 0
        /// Otherwise adds padding and makes them match, because root node is larger than a regular node the padding looks weird even if its even on top and bottom
        ///
        let yCorrection = treeHeight == 0
            ? ProgressTreeCardView.squareCanvasSize / 2
            : newPadding / 2 - (TreeNodeView.defaultRootNodeSize / sqrt(2) - TreeNodeView.defaultSize) / 2

        let scaleX = (treeWidth == 0 ? 1 : (ProgressTreeCardView.squareCanvasSize - newPadding) / treeWidth)

        let scaleY = treeHeight == 0 ? 1 : (ProgressTreeCardView.squareCanvasSize - newPadding) / treeHeight

        scale = scaleX > scaleY ? scaleY : scaleX

        scaleNodeCoord = { node in
            CGPoint(
                x: (node.coordinates.x - removeLeftPadding) * scaleX + xCorrection,
                y: (node.coordinates.y - removeTopPadding) * scaleY + yCorrection)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ProgressTree.self, configurations: config)

    let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .green)

    let rootNode = TreeNode(name: "Root", emojiIcon: "👨🏻‍🍳")
    rootNode.orderKey = 1000
    container.mainContext.insert(rootNode)
    rootNode.progressTree = tree
    tree.treeNodes.append(rootNode)
    try? container.mainContext.save()

    let childNode1 = TreeNode(name: "LEVEL 1", emojiIcon: "👨🏻‍🍳")
    childNode1.orderKey = 2000
    container.mainContext.insert(childNode1)
    childNode1.progressTree = tree
    childNode1.parent = rootNode
    rootNode.successors.append(childNode1)
    tree.treeNodes.append(childNode1)

    let childNode12 = TreeNode(name: "LEVEL 1.2", emojiIcon: "👨🏻‍🍳")
    childNode12.orderKey = 3000
    container.mainContext.insert(childNode12)
    childNode12.progressTree = tree
    childNode12.parent = rootNode
    rootNode.successors.append(childNode12)
    tree.treeNodes.append(childNode12)

    _ = tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    return ProgressTreeCardView(tree: tree)
        .modelContainer(container)
}

