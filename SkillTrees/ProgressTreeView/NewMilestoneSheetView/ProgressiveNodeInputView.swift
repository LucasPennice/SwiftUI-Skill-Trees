//
//  RepeatingNodeInputView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 20/08/2024.
//

import SwiftUI

struct ProgressiveNodeInputView: View {
    @Binding var unitInteger: Int
    @Binding var unitDecimal: Double
    @Binding var unit: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("TARGET AMOUNT & UNIT")
                .font(.system(size: 12))
                .foregroundColor(AppColors.textGray)

            HStack(spacing: 0) {
                Picker(selection: $unitInteger, label: Text("Picker")) {
                    ForEach(stride(from: 0, to: 500, by: 1).map({ $0 }), id: \.self) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: -32))
                .padding(.trailing, -32)
                .frame(minWidth: 0, maxWidth: .infinity)

                Picker(selection: $unitDecimal, label: Text("Picker")) {
                    ForEach(stride(from: 0, to: 1, by: 0.25).map({ $0 }), id: \.self) { number in
                        Text("\(String(number))")
                            .tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipShape(.rect.offset(x: 16))
                .padding(.leading, -16)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 100)
            .background(AppColors.midGray)
            .cornerRadius(13)

            TextField("Unit", text: $unit)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 45)
                .padding(.horizontal)
                .background(AppColors.midGray)
                .cornerRadius(10)
                .padding(.bottom, 5)
        }
        .transition(.blurReplace)
    }
}

#Preview {
    ProgressiveNodeInputView(unitInteger: .constant(0), unitDecimal: .constant(0.0), unit: .constant(""))
}
