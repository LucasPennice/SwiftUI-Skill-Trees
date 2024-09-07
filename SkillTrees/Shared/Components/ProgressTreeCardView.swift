//
//  ProgressTreeCardView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//
import SwiftData
import SwiftUI

struct ProgressTreeCardView: View {
    static let cardHeight: Double = 350
    static let canvasHeight: Double = 200

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

    var rootNode: TreeNode

    var nextMilestone: TreeNode? { return rootNode.findFirstIncompleteNode(rootNode) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ///
            /// Tree Preview
            ///

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
                            startY: node.parent == nil ? coordinates.y : coordinates.y - newNodeSize / 2,
                            endX: successorCoord.x,
                            endY: successorCoord.y + newNodeSize / 2
                        )
                        .stroke(successor.complete ? successor.color : AppColors.midGray, lineWidth: 2)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: ProgressTreeCardView.canvasHeight)
            .background(AppColors.darkGray)
            .cornerRadius(10)
            .clipped()
            .drawingGroup()
            .allowsHitTesting(false)
            .padding()

            VStack {
                ///
                /// Card Header
                ///
                VStack(spacing: 5) {
                    HStack {
                        Text(tree.name)
                            .font(.system(size: 22).weight(.bold))

                        Spacer()
                    }

                    ProgressView(value: tree.progress)
                        .tint(tree.color)
                        .background(AppColors.darkGray)
                        .cornerRadius(10)
                }

                Spacer()

                if nextMilestone != nil {
                    ///
                    /// Card Footer
                    ///
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Next Milestone")
                            .font(.system(size: 14))
                            .opacity(0.4)

                        HStack {
                            Text(nextMilestone!.emojiIcon)
                                .font(.system(size: 14))

                            Text(nextMilestone!.name)
                                .font(.system(size: 16))
                                .opacity(0.8)

                            Spacer()

                            CircularProgressView(strokeColor: nextMilestone!.color, bgColor: AppColors.midGray, size: 15, progress: nextMilestone!.calculateProgress())
                        }
                        .frame(height: 32)
                        .padding(.horizontal)
                        .background(AppColors.darkGray)
                        .cornerRadius(10)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .listRowInsets(EdgeInsets())
        .frame(height: ProgressTreeCardView.cardHeight)
        .background(AppColors.semiDarkGray)
        .cornerRadius(10)
    }

    init(tree: ProgressTree) {
        self.tree = tree

        var minX: Double?
        var maxX: Double?
        var minY: Double?
        var maxY: Double?

        var root: TreeNode?

        for node in tree.treeNodes {
            if node.parent == nil { root = node }

            if minX == nil || node.coordinates.x < minX! { minX = node.coordinates.x }
            if minY == nil || node.coordinates.y < minY! { minY = node.coordinates.y }

            if maxX == nil || node.coordinates.x > maxX! { maxX = node.coordinates.x }
            if maxY == nil || node.coordinates.y > maxY! { maxY = node.coordinates.y }
        }

        let removeTopPadding = minY!

        let treeWidth = maxX! - minX!
        let treeHeight = maxY! - minY!

        let newPadding = 1.3 * TreeNodeView.defaultRootNodeSize

        ///
        /// Center root node when treeHeight = 0
        /// Otherwise adds padding and makes them match, because root node is larger than a regular node the padding looks weird even if its even on top and bottom
        ///
        let yCorrection = treeHeight == 0
            ? ProgressTreeCardView.canvasHeight / 2
            : newPadding / 2 - (TreeNodeView.defaultRootNodeSize / sqrt(2) - TreeNodeView.defaultSize) / 2

        let canvasWidth = UIScreen.main.bounds.width - 64
        
        var scaleX = (treeWidth == 0 ? 1 : (canvasWidth - newPadding) / treeWidth)
        scaleX = scaleX < 0.3 ? 0.3 : scaleX

        var scaleY = treeHeight == 0 ? 1 : (ProgressTreeCardView.canvasHeight - newPadding) / treeHeight
        scaleY = scaleY < 0.35 ? 0.35 : scaleY

        let calculatedScale = scaleX > scaleY ? scaleY : scaleX

        scale = calculatedScale < 0.6 ? 0.6 : calculatedScale

        scaleNodeCoord = { node in
            CGPoint(
                x: ((node.coordinates.x - root!.coordinates.x) * calculatedScale) + canvasWidth / 2,
                y: (node.coordinates.y - removeTopPadding) * scaleY + yCorrection)
        }

        rootNode = root!
    }
}

#Preview {
    let container = SwiftDataController.previewContainer

    let descriptor = FetchDescriptor<ProgressTree>()

    let trees = try? container.mainContext.fetch(descriptor)

    return ProgressTreeCardView(tree: trees![0])
        .modelContainer(container)
}
