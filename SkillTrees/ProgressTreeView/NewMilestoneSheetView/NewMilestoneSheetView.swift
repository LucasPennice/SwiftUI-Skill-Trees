//
//  NewMilestoneSheetView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 20/08/2024.
//

import SwiftData
import SwiftUI

struct NewMilestoneSheetView: View {
    @Environment(\.dismiss) var dismiss

    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: { viewModel.showingEmojiPicker.toggle() }) {
                            Text(viewModel.emojiIcon)
                                .font(.system(size: 18))
                                .frame(width: 45, height: 45)
                                .background(AppColors.midGray)
                                .cornerRadius(10)
                        }

                        .padding(.bottom, 5)
                        .emojiPicker(
                            isPresented: $viewModel.showingEmojiPicker,
                            selectedEmoji: $viewModel.emojiIcon)

                        TextField("Title", text: $viewModel.name)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 45)
                            .padding(.horizontal)
                            .background(AppColors.midGray)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .tappableTextField()
                    }

                    ColorPicker("Color", selection: $viewModel.color, supportsOpacity: false)
                        .frame(height: 45)
                        .padding(.horizontal)
                        .background(AppColors.midGray)
                        .cornerRadius(10)
                        .padding(.bottom, 15)

                    Text("WHEN DO I COMPLETE THIS MILESTONE?")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textGray)

                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: { withAnimation { viewModel.selectedCompletionType = .List }}) {
                            HStack {
                                Text("When I finish every item on a list")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)

                                Spacer()

                                Image(systemName: "checkmark")
                                    .fontWeight(.medium)
                                    .opacity(viewModel.selectedCompletionType == .List ? 1 : 0)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }

                        Divider()

                        Button(action: { withAnimation { viewModel.selectedCompletionType = .Repeat }}) {
                            HStack {
                                Text("When I do a task a certain number of times")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)

                                Spacer()

                                Image(systemName: "checkmark")
                                    .fontWeight(.medium)
                                    .opacity(viewModel.selectedCompletionType == .Repeat ? 1 : 0)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }

                        Divider()

                        Button(action: { withAnimation { viewModel.selectedCompletionType = .Progressive }}) {
                            HStack {
                                Text("When I hit a target amount")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)

                                Spacer()

                                Image(systemName: "checkmark")
                                    .fontWeight(.medium)
                                    .opacity(viewModel.selectedCompletionType == .Progressive ? 1 : 0)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                    }
                    .background(AppColors.midGray)
                    .cornerRadius(10)
                    .padding(.bottom, 15)

                    if viewModel.selectedCompletionType == .List {
                        ListNodeInputView(items: $viewModel.items)
                    } else if viewModel.selectedCompletionType == .Progressive {
                        ProgressiveNodeInputView(unitInteger: $viewModel.unitInteger, unitDecimal: $viewModel.unitDecimal, unit: $viewModel.unit)
                    } else if viewModel.selectedCompletionType == .Repeat {
                        RepeatingNodeInputView(repeatTimesToComplete: $viewModel.repeatTimesToComplete)
                    }
                }
                .navigationTitle("New Milestone")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") { viewModel.addNodeAndClose(dismiss: dismiss) }
                            .disabled(viewModel.addDisabled)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .presentationDetents([.height(UIScreen.main.bounds.height - 250)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
    }

    init(insertNodePosition: InsertNodePosition, treeColor: Color, addTreeNode: @escaping (TreeNode, PersistentIdentifier) -> Void) {
        _viewModel = State(initialValue: ViewModel(addTreeNode: addTreeNode, insertNodePosition: insertNodePosition, treeColor: treeColor))
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

    return NewMilestoneSheetView(insertNodePosition: InsertNodePosition(id: UUID(), parentId: childNode1.persistentModelID, orderKey: 123, coordinates: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)), treeColor: tree.color, addTreeNode: { _, _ in })
        .modelContainer(container)
}
