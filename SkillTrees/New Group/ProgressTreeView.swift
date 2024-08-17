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
                            EdgeView(startX: node.coordinates.x, startY: node.coordinates.y, endX: successor.coordinates.x, endY: successor.coordinates.y)
                                .stroke(viewModel.progressTree.color, lineWidth: 2)
                        }
                    }

                    ///
                    /// Node Labels
                    ///
                    ForEach(viewModel.progressTree.treeNodes) { node in
                        Text("\(node.name) - C \(node.successors.count) - p \(node.parent?.name ?? "")")
                            .frame(maxWidth: 100)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(7)
                            .background(AppColors.darkGray)
                            .cornerRadius(7)
                            .foregroundColor(.white)
                            .position(CGPoint(x: node.coordinates.x, y: node.coordinates.y))
                            .offset(y: TreeNodeView.defaultSize / 2 + viewModel.getLabelVerticalOffset(text: node.name) + 10)
                            .zIndex(1)
                    }

                    ///
                    /// Node View
                    ///
                    ForEach(viewModel.progressTree.treeNodes) { node in
                        TreeNodeView(icon: node.emojiIcon, size: viewModel.selectedNode == node.persistentModelID ? TreeNodeView.defaultSize * 2 : TreeNodeView.defaultSize, color: viewModel.progressTree.color)
                            .id(node.persistentModelID)
                            .zIndex(2)
                            .clipShape(Circle())
                            .contentShape(ContentShapeKinds.contextMenuPreview, Circle())
                            .gesture(
                                SimultaneousGesture(
                                    ///
                                    /// Tap Gesture
                                    ///
                                    TapGesture(count: 1).onEnded({ withAnimation {
//                                        viewModel.selectNode(nodeId: node.persistentModelID)
//                                        viewModel.addTreeNode(parentNode: node)
                                        viewModel.deleteNode(node)
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
                            /// Node Context Menu
                            ///
                            .contextMenu(menuItems: {
                                Text("Menu Item 1")
                                Text("Menu Item 2")
                                Button(role: .destructive) {
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            )
                            ///
                            /// Node Position State, updates on drag
                            ///
                            .position(CGPoint(x: node.coordinates.x + positionDelta.width, y: node.coordinates.y + positionDelta.height))
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
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16).bold())
                    .frame(width: 30, height: 30)
                    .foregroundColor(AppColors.textGray)
                    .background(AppColors.midGray)
                    .cornerRadius(50)
            }
            .padding(12)
        }
        ///
        /// Add Node Button
        ///
        .overlay(alignment: .topTrailing) {
            Button(action: { print(viewModel.progressTree.treeNodes) }) {
                Image(systemName: "plus")
                    .font(.system(size: 16).bold())
                    .frame(width: 30, height: 30)
                    .foregroundColor(AppColors.textGray)
                    .background(AppColors.midGray)
                    .cornerRadius(50)
            }
            .padding(12)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    init(modelContext: ModelContext, tree: ProgressTree) {
        _viewModel = State(initialValue: ViewModel(modelContext: modelContext, progressTreeId: tree.persistentModelID))
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
    
    let childNode21 = TreeNode(name: "LEVEL 2.1", emojiIcon: "👨🏻‍🍳")
    childNode12.orderKey = 4
    container.mainContext.insert(childNode21)
    childNode21.progressTree = tree
    childNode21.parent = childNode12
    childNode12.successors.append(childNode21)
    tree.treeNodes.append(childNode21)

    _ = tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    return ProgressTreeView(modelContext: container.mainContext, tree: tree)
        .modelContainer(container)
}
