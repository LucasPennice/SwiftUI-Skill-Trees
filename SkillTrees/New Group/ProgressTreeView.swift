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

    var canvasWidth = UIScreen.main.bounds.width
    var canvasHeight = UIScreen.main.bounds.height

    #warning("me quede viendo como meto las coordenadas de los nodos a la estructura de datos")
    #warning("tambien necesito una forma de ubicar a las labels por debajo de los nodos")
    #warning("tambien necesito una forma de hacer los edges. Pero que salgan desde el padre hasta los hijos. O sea que se rendericen desde node.successors")

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
                    ForEach(viewModel.treeNodes) {
                        Text("\($0.name) - C \($0.successors.count)")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(7)
                            .background(AppColors.darkGray)
                            .cornerRadius(7)
                            .foregroundColor(.white)
                            .position(CGPoint(x: $0.coordinates.x, y: $0.coordinates.y + 30))
                            .zIndex(1)
                    }

                    ///
                    /// Node View
                    ///
                    ForEach(viewModel.treeNodes) { node in
                        TreeNodeView(icon: node.emojiIcon, size: selectedNode == "🔥" ? TreeNodeView.defaultSize * 2 : TreeNodeView.defaultSize, color: .yellow)
                            .zIndex(2)
                            .clipShape(Circle())
                            .contentShape(ContentShapeKinds.contextMenuPreview, Circle())
                            .gesture(
                                SimultaneousGesture(
                                    ///
                                    /// Tap Gesture
                                    ///
                                    TapGesture(count: 1).onEnded({ withAnimation { viewModel.deleteNode(node) } }),
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
                .frame(width: canvasWidth, height: canvasHeight)
                .background(.black)
                .defaultScrollAnchor(.center)
                .onTapGesture {
                    if selectedNode != nil {
                        withAnimation {
                            selectedNode = nil
                        }
                    }
                }

//                .drawingGroup()
            }
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
            Button(action: { print(viewModel.treeNodes) }) {
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
        _viewModel = State(initialValue: ViewModel(modelContext: modelContext, progressTree: tree))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ProgressTree.self, configurations: config)

    let tree = ProgressTree(name: "Cooking", emojiIcon: "👨🏻‍🍳", color: .blue, treeNodes: [])

    container.mainContext.insert(tree)

    let rootNode = TreeNode(name: "Cooking", emojiIcon: "👨🏻‍🍳", coordinates: Coordinate(x: 100, y: 100), successors: [])

    let childNode1 = TreeNode(name: "level1", emojiIcon: "👨🏻‍🍳", coordinates: Coordinate(x: 100, y: 200), successors: [], parent: rootNode)

    let childNode2 = TreeNode(name: "level2", emojiIcon: "👨🏻‍🍳", coordinates: Coordinate(x: 100, y: 300), successors: [], parent: childNode1)

    tree.treeNodes.append(rootNode)
    tree.treeNodes.append(childNode1)
    tree.treeNodes.append(childNode2)

    rootNode.successors.append(childNode1)
    childNode1.successors.append(childNode2)

    return ProgressTreeView(modelContext: container.mainContext, tree: tree)
        .modelContainer(container)
}
