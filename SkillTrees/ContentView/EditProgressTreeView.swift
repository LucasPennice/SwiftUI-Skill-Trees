//
//  EditProgressTreeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 25/08/2024.
//

import MCEmojiPicker
import SwiftData
import SwiftUI

struct EditProgressTreeView: View {
    @Environment(\.dismiss) var dismiss

    @Bindable var tree: ProgressTree

    var deleteTree: (ProgressTree) -> Void
    var saveProgressTreeEdit: (ProgressTree) -> Void

    @State private var showingEmojiPicker = false
    @State private var showingDeleteTreeConfirmation = false
    @State private var treeColor: Color {
        didSet { tree.updateColor(treeColor) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: { showingEmojiPicker.toggle() }) {
                    Text(tree.emojiIcon)
                        .font(.system(size: 72))
                        .padding()
                        .background(AppColors.midGray)
                        .cornerRadius(10)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 5)
                .emojiPicker(
                    isPresented: $showingEmojiPicker,
                    selectedEmoji: $tree.emojiIcon)

                TextField("Title", text: $tree.name)
                    .frame(height: 45)
                    .padding(.horizontal)
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .padding(.bottom, 5)

                ColorPicker("Color", selection: $treeColor, supportsOpacity: false)
                    .padding()
                    .background(AppColors.midGray)
                    .cornerRadius(10)

                Spacer()

                Button(action: { showingDeleteTreeConfirmation = true }) {
                    HStack {
                        Text("Delete Progress Tree")
                            .font(.system(size: 16))
                            .foregroundColor(.red)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 45)
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .padding(.bottom, 5)
                }
            }
            .padding()
            .confirmationDialog("Delete this Progress Tree", isPresented: $showingDeleteTreeConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteTree(tree)

                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        saveProgressTreeEdit(tree)

                        dismiss()
                    }) {
                        Text("Save")
                            .foregroundColor(tree.name.isEmpty ? .gray : .accentColor)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    }
                    .disabled(tree.name.isEmpty)
                }
            }
            .interactiveDismissDisabled()
        }
    }

    init(tree: ProgressTree, deleteTree: @escaping (ProgressTree) -> Void, saveProgressTreeEdit: @escaping (ProgressTree) -> Void) {
        _tree = Bindable(tree)
        _treeColor = State(initialValue: tree.color)
        self.deleteTree = deleteTree
        self.saveProgressTreeEdit = saveProgressTreeEdit
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

    return EditProgressTreeView(tree: tree, deleteTree: { _ in }, saveProgressTreeEdit: { _ in })
        .modelContainer(container)
}
