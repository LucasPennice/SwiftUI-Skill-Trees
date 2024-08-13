//
//  ProgressTree.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ProgressTree {
    var name: String
    var emojiIcon: String

    private var colorR: Double
    private var colorG: Double
    private var colorB: Double

    func updateColor(_ newColor: Color) {
        let colorArray = UIColor(newColor).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }

    var color: Color {
        return Color(red: colorR, green: colorG, blue: colorB)
    }

    @Relationship(deleteRule: .cascade, inverse: \TreeNode.progressTree)
    var treeNodes: [TreeNode]
    
    init(name: String, emojiIcon: String, color: Color, treeNodes: [TreeNode]) {
        self.name = name

        self.treeNodes = treeNodes

        self.emojiIcon = emojiIcon

        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
        
        
    }
}
