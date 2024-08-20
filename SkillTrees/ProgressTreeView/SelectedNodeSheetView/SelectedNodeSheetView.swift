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

    @State private var showingDeleteMilestoneConfirmation = false
    @State private var showingDeleteAdditionalConnectionsConfirmation = false

    var body: some View {
        VStack {
            HStack {
                Button(action: { showingEmojiPicker.toggle() }) {
                    Text(node.emojiIcon)
                        .font(.system(size: 18))
                        .frame(width: 45, height: 45)
                        .background(AppColors.midGray)
                        .cornerRadius(10)
                }

                .padding(.bottom, 5)
                .emojiPicker(
                    isPresented: $showingEmojiPicker,
                    selectedEmoji: $node.emojiIcon)

                TextField("Title", text: $node.name)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 45)
                    .padding(.horizontal)
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .padding(.bottom, 5)
            }

            ColorPicker("Color", selection: $nodeColor, supportsOpacity: false)
                .frame(height: 45)
                .padding(.horizontal)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .padding(.bottom, 5)

            /// NOT IMPLEMENTED 🚨
            Button(action: { }) {
                HStack {
                    Text("Move Milestone\(node.successors.isEmpty ? "" : " & Descendants")")
                        .font(.system(size: 18))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 45)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .padding(.bottom, 5)
            }

            /// NOT IMPLEMENTED 🚨
            Button(action: { }) {
                HStack {
                    Text("Connect to Additional Milestone")
                        .font(.system(size: 18))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 45)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .padding(.bottom, 5)
            }

            Button(action: { showingDeleteAdditionalConnectionsConfirmation = true }) {
                HStack {
                    Text("Delete Additional Milestone Connections")
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

            Button(action: { showingDeleteMilestoneConfirmation = true }) {
                HStack {
                    Text("Delete Milestone")
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
        .presentationDetents([.height(UIScreen.main.bounds.height - 250)])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
        .confirmationDialog("Delete Additional Connections?", isPresented: $showingDeleteAdditionalConnectionsConfirmation) {
            /// NOT IMPLEMENTED 🚨
            Button("Delete Additional Connections", role: .destructive) {}
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Delete this Milestone\(node.successors.isEmpty ? "" : " & All Descendants")", isPresented: $showingDeleteMilestoneConfirmation) {
            /// NOT IMPLEMENTED 🚨
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) { }
        }
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

    return SelectedNodeSheetView(node: rootNode)
        .modelContainer(container)
}
