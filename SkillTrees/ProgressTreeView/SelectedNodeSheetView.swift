//
//  SelectedNodeSheetView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 17/08/2024.
//

import MCEmojiPicker
import SwiftData
import SwiftUI

struct SelectedNodeSheetView: View {
    @Bindable var node: TreeNode

    @State private var showingEmojiPicker: Bool
    @State private var nodeColor: Color {
        didSet { node.updateColor(nodeColor) }
    }

    var body: some View {
        VStack {
            Button(action: { showingEmojiPicker.toggle() }) {
                Text(node.emojiIcon)
                    .font(.system(size: 72))
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.bottom, 5)
            .emojiPicker(
                isPresented: $showingEmojiPicker,
                selectedEmoji: $node.emojiIcon)

            TextField("Title", text: $node.name)
                .frame(height: 45)
                .padding(.horizontal)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .padding(.bottom, 5)

            ColorPicker("Color", selection: $nodeColor, supportsOpacity: false)
                .padding()
                .background(AppColors.midGray)
                .cornerRadius(10)
        }
        .padding()
        .presentationDetents([.height(UIScreen.main.bounds.height - 250)])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
    }

    init(node: TreeNode) {
        _node = Bindable(node)
        _showingEmojiPicker = State(initialValue: false)
        _nodeColor = State(initialValue: node.color)
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
    childNode1.updateColor(.red)

    return SelectedNodeSheetView(node: childNode1)
        .modelContainer(container)
}
