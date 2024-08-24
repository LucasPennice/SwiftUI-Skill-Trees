//
//  ProgressTreeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//

import SwiftData
import SwiftUI

struct ProgressTreeView: View {
    @State private var viewModel: ViewModel

    @Environment(\.dismiss) var dismiss

    @State private var positionDelta = CGSize.zero

    let lowOpacity = 0.4

    var rootEdgeStartDelta: Double {
        /// This is so the edge will start precisely at the rhombus edge, so when the opacity is != 1 it looks right
        /// First part is the distance from the center to the edge of the rhombus
        /// Second part is the distance from the center to the edge of a regular node
        /// Third part is a corrector factor to be more precise
        return TreeNodeView.defaultRootNodeSize / sqrt(2) - TreeNodeView.defaultSize / 2 - 2
    }

    #warning("no anda el scroll on tap")

    var body: some View {
        ScrollViewReader { _ in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack {
                    ///
                    /// Node Edges
                    ///
                    ForEach(viewModel.progressTree.treeNodes) { node in
                        ForEach(node.successors) { successor in
                            EdgeView(
                                startX: node.coordinates.x,
                                startY: node.parent == nil ? node.coordinates.y + rootEdgeStartDelta : node.coordinates.y,
                                endX: successor.coordinates.x,
                                endY: successor.coordinates.y
                            )
                            .stroke(viewModel.progressTree.color, lineWidth: 2)
                            .opacity(viewModel.showingInsertNodePositions ? lowOpacity : 1)
                        }
                    }

                    ///
                    /// Node Labels
                    ///
                    ForEach(viewModel.progressTree.treeNodes) { node in
                        Text("\(node.name) - C \(node.successors.count) - p \(node.parent?.name ?? "")")
                            .id(node.persistentModelID)
                            .frame(maxWidth: 100)
                            .font(.system(size: 14))
                            .opacity(viewModel.showingInsertNodePositions ? lowOpacity : 1)
                            .multilineTextAlignment(.center)
                            .padding(7)
                            .background(AppColors.darkGray)
                            .cornerRadius(7)
                            .foregroundColor(.white)
                            .position(CGPoint(x: node.coordinates.x, y: node.coordinates.y))
                            .offset(y: TreeNodeView.defaultSize / 2 + viewModel.getLabelVerticalOffset(text: node.name) + 20)
                            .zIndex(1)
                    }

                    ///
                    /// Node View
                    ///
                    ForEach(viewModel.progressTree.treeNodes) { node in
                        TreeNodeView(node: node, selected: viewModel.selectedNode?.persistentModelID == node.persistentModelID)
                            .zIndex(2)
                            .opacity(viewModel.showingInsertNodePositions ? lowOpacity : 1)
                            .allowsHitTesting(!viewModel.showingInsertNodePositions)
                            .gesture(
                                SimultaneousGesture(
                                    ///
                                    /// Tap Gesture
                                    ///
                                    TapGesture(count: 1).onEnded({ withAnimation {
                                        viewModel.selectNode(node)
//                                        viewModel.addTreeNode(parentNode: node)
//                                        viewModel.deleteNode(node)
                                    } }),
                                    ///
                                    /// Drag Gesture
                                    ///
                                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                        .onChanged { positionDelta = $0.translation }
                                        .onEnded { _ in
                                            withAnimation {
                                                positionDelta = CGSize.zero
                                            }
                                        }
                                )
                            )
                            ///
                            /// Node Position State, updates on drag
                            ///
                            .position(CGPoint(x: node.coordinates.x + positionDelta.width, y: node.coordinates.y + positionDelta.height))
                    }

                    ///
                    /// Insert Node Position
                    ///
                    if viewModel.showingInsertNodePositions {
                        ForEach(viewModel.insertNodePositions) { insertNodePosition in
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .stroke(AppColors.textGray, style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .fill(
                                    viewModel.selectedInsertNodePosition?.id == insertNodePosition.id
                                        ? Color.accentColor.opacity(0.4)
                                        : AppColors.textGray.opacity(0.4))
                                .frame(width: insertNodePosition.size.width, height: insertNodePosition.size.height)
                                .position(CGPoint(x: insertNodePosition.coordinates.x, y: insertNodePosition.coordinates.y))
                                .transition(.blurReplace)
                                .zIndex(3)
                                .onTapGesture { viewModel.tapInsertNodePosition(insertNodePosition) }
                        }
                    }
                }
                .frame(width: viewModel.canvasSize.width, height: viewModel.canvasSize.height)
                .background(.black)
                .defaultScrollAnchor(.center)
                .onTapGesture { if viewModel.selectedNode != nil { withAnimation { viewModel.selectedNode = nil }} }
            }
            .defaultScrollAnchor(.center)
        }
        ///
        /// Back Button
        ///
        .overlay(alignment: .topLeading) {
            Button(action: {
                if viewModel.showingInsertNodePositions { return withAnimation { viewModel.hideInsertNodePositions() }}

                dismiss()
            }) {
                ZStack {
                    if viewModel.showingInsertNodePositions {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .transition(.blurReplace)
                            .zIndex(1)
                    } else {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16).bold())
                            .foregroundColor(AppColors.textGray)
                            .transition(.blurReplace)
                            .zIndex(2)
                    }
                }
                .frame(width: viewModel.showingInsertNodePositions ? 80 : 30, height: 30)
                .background(AppColors.midGray)
                .cornerRadius(50)
            }
            .padding(12)
            .opacity(viewModel.selectedNode == nil ? 1 : 0)
        }
        ///
        /// Add Node Button
        ///
        .overlay(alignment: .topTrailing) {
            Button(action: { withAnimation { viewModel.showInsertNodePositions() } }) {
                ZStack {
                    if viewModel.showingInsertNodePositions {
                        Text("Choose where to add your milestone")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .transition(.blurReplace)
                            .zIndex(1)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 16).bold())
                            .foregroundColor(AppColors.textGray)
                            .transition(.blurReplace)
                            .zIndex(2)
                    }
                }
                .frame(width: viewModel.showingInsertNodePositions ? 170 : 30, height: viewModel.showingInsertNodePositions ? 50 : 30)
                .background(AppColors.midGray)
                .cornerRadius(viewModel.showingInsertNodePositions ? 10 : 50)
            }
            .padding(12)
            .opacity(viewModel.selectedNode == nil ? 1 : 0)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $viewModel.selectedNode, content: { SelectedNodeSheetView(node: $0) })
        .sheet(item: $viewModel.selectedInsertNodePosition, content: { NewMilestoneSheetView(insertNodePosition: $0, treeColor: viewModel.progressTree.color) })
    }

    init(modelContext: ModelContext, progressTreeId: PersistentIdentifier) {
        _viewModel = State(initialValue: ViewModel(modelContext: modelContext, progressTreeId: progressTreeId))
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

    let childNode12 = TreeNode(name: "LEVEL 1.2", emojiIcon: "👨🏻‍🍳")
    childNode12.orderKey = 3
    container.mainContext.insert(childNode12)
    childNode12.progressTree = tree
    childNode12.parent = rootNode
    rootNode.successors.append(childNode12)
    tree.treeNodes.append(childNode12)

    _ = tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    return ProgressTreeView(modelContext: container.mainContext, progressTreeId: tree.persistentModelID)
        .modelContainer(container)
}
