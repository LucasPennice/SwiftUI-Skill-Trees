//
//  ListNodeInputView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 21/08/2024.
//

import SwiftUI

struct ListNodeInputView: View {
    @Binding var items: [NodeListItem]
    @State private var text: String = ""

    func runOnSubmit() {
        if text.isEmpty { return }

        let newItem = NodeListItem(name: text, complete: false)

        withAnimation {
            items.append(newItem)

            text = ""
        }
    }

    func removeItem(_ item: NodeListItem) {
        let itemIndex = items.firstIndex(where: { $0.id == item.id })

        withAnimation {
            items.remove(at: itemIndex!)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("LIST")
                .font(.system(size: 12))
                .foregroundColor(AppColors.textGray)

            ForEach(items) { item in
                HStack {
                    Image(systemName: "circle")
                        .font(.system(size: 13))
                        .opacity(0.5)

                    Text(item.name)

                    Spacer()

                    Button(action: { removeItem(item) }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundStyle(AppColors.textGray)
                            .frame(width: 45, height: 45)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .frame(height: 45)
                .padding(.leading)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .transition(.blurReplace)
            }

            HStack {
                TextField("New Item", text: $text)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 45)
                    .padding(.leading)
                    .submitLabel(.done)
                    .onSubmit { runOnSubmit() }
                    .tappableTextField()

                Button(action: { runOnSubmit() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.accentColor, Color.accentColor.opacity(0.3))
                        .symbolRenderingMode(.palette)
                        .frame(width: 45, height: 45)
                        .contentShape(Rectangle())
                }
            }
            .background(AppColors.midGray)
            .cornerRadius(10)
        }
        .transition(.blurReplace)
    }
}

#Preview {
    ListNodeInputView(items: .constant([NodeListItem(name: "Pasear perro", complete: false), NodeListItem(name: "Pasear perro", complete: true)]))
}
