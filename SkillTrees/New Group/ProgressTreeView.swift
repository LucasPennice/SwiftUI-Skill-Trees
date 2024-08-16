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
    @State private var selectedNode: String?

    #warning("me quede viendo como meto las coordenadas de los nodos a la estructura de datos")
    #warning("tambien necesito una forma de hacer los edges. Pero que salgan desde el padre hasta los hijos. O sea que se rendericen desde node.successors")
    #warning("no anda el delete ene cascada. habra que hacer una funcion a mano")

    var body: some View {
        ScrollViewReader { _ in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack {
                    ///
                    /// Node Edge
                    ///
//                    Text("EDGE")
//                        .multilineTextAlignment(.center)
//                        .padding(10)
//                        .background(AppColors.darkGray)
//                        .cornerRadius(10)
//                        .foregroundColor(AppColors.textGray)
//                        .position(CGPoint(x: $0.coordinates.x - 40, y: $0.coordinates.y))
//                        .zIndex(0)

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
                        TreeNodeView(icon: node.emojiIcon, size: selectedNode == "🔥" ? TreeNodeView.defaultSize * 2 : TreeNodeView.defaultSize, color: .yellow)
                            .zIndex(2)
                            .clipShape(Circle())
                            .contentShape(ContentShapeKinds.contextMenuPreview, Circle())
                            .gesture(
                                SimultaneousGesture(
                                    ///
                                    /// Tap Gesture
                                    ///
                                    TapGesture(count: 1).onEnded({ withAnimation {
//                                        viewModel.deleteNode(node)
                                        viewModel.addTreeNode(parentNode: node)
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
                        //                        .id(nodeId)
                    }
                }
                .frame(width: viewModel.canvasSize.width, height: viewModel.canvasSize.height)
                .background(.black)
                .defaultScrollAnchor(.center)
                .onTapGesture {
                    if selectedNode != nil {
                        withAnimation {
                            selectedNode = nil
                        }
                    }
                }
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
    container.mainContext.insert(rootNode)
    rootNode.progressTree = tree
    tree.treeNodes.append(rootNode)
    try? container.mainContext.save()

    let childNode1 = TreeNode(name: "LEVEL 1", emojiIcon: "👨🏻‍🍳")
    container.mainContext.insert(childNode1)
    childNode1.progressTree = tree
    childNode1.parent = rootNode
    rootNode.successors.append(childNode1)
    tree.treeNodes.append(childNode1)

    let childNode12 = TreeNode(name: "LEVEL 1.2", emojiIcon: "👨🏻‍🍳")
    container.mainContext.insert(childNode12)
    childNode12.progressTree = tree
    childNode12.parent = rootNode
    rootNode.successors.append(childNode12)
    tree.treeNodes.append(childNode12)

    tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    return ProgressTreeView(modelContext: container.mainContext, tree: tree)
        .modelContainer(container)
}
