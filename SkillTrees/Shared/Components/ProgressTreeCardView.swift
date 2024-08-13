//
//  ProgressTreeCardView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 13/08/2024.
//
import SwiftData
import SwiftUI

struct ProgressTreeCardView: View {
    var tree: ProgressTree

    var body: some View {
        ZStack(alignment: .leading) {
            ///
            /// Tree Preview
            ///
            HStack {
                Spacer()

                /// Preview of tree (🚨 NOT IMPLEMENTED)
                Rectangle()
                    .fill(AppColors.darkGray)
                    .aspectRatio(1.0, contentMode: .fit)
            }
            GeometryReader { proxy in
                VStack {
                    ///
                    /// Card Header
                    ///
                    VStack(spacing: 10) {
                        HStack {
                            Text(tree.emojiIcon)

                            Text(tree.name)
                                .font(.system(size: 20).weight(.medium))

                            Spacer()
                        }

                        /// Tree Progress (🚨 NOT IMPLEMENTED)
                        ProgressView(value: 0.25)
                            .scaleEffect(y: 1.2)
                            .tint(tree.color)
                    }

                    Spacer()

                    ///
                    /// Card Footer
                    ///
                    VStack(alignment: .leading, spacing: 5) {
                        /// NEXT MILESTONE (🚨 NOT IMPLEMENTED)
                        Text("Next Milestone")
                            .font(.system(size: 16))

                        HStack {
                            Text(tree.emojiIcon)
                                .font(.system(size: 14))

                            Text("Finish Thesis")
                                .font(.system(size: 16))
                                .opacity(0.8)

                            Spacer()

                            CircularProgressView(strokeColor: tree.color, bgColor: AppColors.midGray, size: 15, progress: 0.24)
                        }
                        .frame(height: 32)
                        .padding(.horizontal, 5)
                        .background(AppColors.darkGray)
                        .cornerRadius(10)
                    }
                }
                .frame(minHeight: 0, maxHeight: .infinity)
                .frame(width: proxy.size.width - 180 * 2 / 3, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
        }
        .listRowInsets(EdgeInsets())
        .frame(height: 180.0)
        .background(AppColors.semiDarkGray)
        .cornerRadius(10)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ProgressTree.self, configurations: config)

    return ProgressTreeCardView(tree: ProgressTree(name: "Test Tree", emojiIcon: "🌳", color: .green, treeNodes: []))

        .modelContainer(container)
}
