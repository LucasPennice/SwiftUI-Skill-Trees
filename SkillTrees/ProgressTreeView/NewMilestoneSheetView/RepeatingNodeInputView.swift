//
//  RepeatingNodeInputView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 21/08/2024.
//

import SwiftUI

struct RepeatingNodeInputView: View {
    @Binding var repeatTimesToComplete: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("REPETITIONS")
                .font(.system(size: 12))
                .foregroundColor(AppColors.textGray)

            Picker(selection: $repeatTimesToComplete, label: Text("Picker")) {
                ForEach(stride(from: 1, to: 1000, by: 1).map({ $0 }), id: \.self) { number in
                    Text("\(String(number))")
                        .tag(number)
                }
            }
            .pickerStyle(.wheel)
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 100)
            .background(AppColors.midGray)
            .cornerRadius(13)
        }
        .transition(.blurReplace)
    }
}

#Preview {
    RepeatingNodeInputView(repeatTimesToComplete: .constant(1))
}
