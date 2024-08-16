//
//  AddNewProgressTreeView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import MCEmojiPicker
import SwiftData
import SwiftUI

struct AddNewProgressTreeView: View {
    @Environment(\.dismiss) var dismiss

    var addProgressTree: (ProgressTree) -> Void

    @State private var title = ""
    @State private var selectedEmoji = "🌳"
    @State private var showingEmojiPicker = false
    @State private var treeColor = Color.green

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Cancel")
                        .onTapGesture(perform: { dismiss() })
                        .foregroundColor(.accentColor)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)

                    Spacer()

                    Text("New Progress Tree")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)

                    Spacer()

                    Text("Add")
                        .onTapGesture {
                            if title.isEmpty { return }

                            addProgressTree(ProgressTree(name: title, emojiIcon: selectedEmoji, color: treeColor))

                            dismiss()
                        }
                        .foregroundColor(title.isEmpty ? .gray : .accentColor)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                }

                Divider()
                    .padding(.bottom, 5)

                Text("Templates")
                    .font(.system(size: 17))

                ScrollView(.horizontal) {
                    HStack {
                        VStack(alignment: .center, spacing: 5) {
                            ZStack {
                                Circle()
                                    .foregroundColor(AppColors.midGray)

                                Image(systemName: "plus.app.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.accentColor)
                                    .symbolRenderingMode(.hierarchical)
                                    .offset(x: 28, y: 28)
                            }
                            .frame(width: 70, height: 70)

                            Text("Cooking")
                                .font(.system(size: 10))
                        }
                    }
                }
                .padding(.vertical, 5)

                Divider()
                    .padding(.bottom, 5)

                Button(action: { showingEmojiPicker.toggle() }) {
                    Text(selectedEmoji)
                        .font(.system(size: 72))
                        .padding()
                        .background(AppColors.midGray)
                        .cornerRadius(10)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 5)
                .emojiPicker(
                    isPresented: $showingEmojiPicker,
                    selectedEmoji: $selectedEmoji)

                TextField("Title", text: $title)
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
            }
            .padding()
            .background(AppColors.semiDarkGray)
        }
    }
}

#Preview {
    AddNewProgressTreeView(addProgressTree: { _ in })
        .modelContainer(SwiftDataController.previewContainer)
}
