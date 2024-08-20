//
//  TreeNode.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct Coordinate: Codable {
    var x: Double
    var y: Double

    static var zero = Coordinate()

    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    init() {
        x = 0
        y = 0
    }
}

@Model
final class TreeNode {
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

    var layer: Int = 0

    var coordinates: Coordinate = Coordinate.zero

    var progressTree: ProgressTree? {
        didSet {
            let colorArray = UIColor(progressTree.color).cgColor.components!

            let red = colorArray[0]
            let green = colorArray[1]
            let blue = colorArray[2]

            colorR = Double(red)
            colorG = Double(green)
            colorB = Double(blue)
        }
    }

    var parent: TreeNode?

    /// Only used to force a specific order (because append order is not reliable on Swift Data)
    var orderKey: Int

    @Relationship(deleteRule: .cascade, inverse: \TreeNode.parent)
    var successors: [TreeNode] = []

    var sortedSuccessors: [TreeNode] {
        successors.sorted(by: { $0.orderKey < $1.orderKey })
    }

    var additionalParents: [TreeNode]

    ///
    /// Data Related Attributes
    ///
    private(set) var complete: Bool
    var name: String
    var emojiIcon: String

    ///
    /// Progress Tree Related Attributes
    ///
    private(set) var progressiveQuest: Bool = false
    var unit: String = ""
    var amount: Double = 0.0
    var targetAmount: Double = 0.0
    @Relationship(deleteRule: .cascade, inverse: \ItemCompletionRecord.treeNode)
    var completionHistory: [ItemCompletionRecord] = []
    ///

    func enableProgressiveQuest() { progressiveQuest = true }

    var items: [NodeListItem] = []

    /// Number of times the action has to be performed to complete the node
    var repeatTimesToComplete: Int

    func undoCompletion(_ date: Date = .now) {
        //
    }

    func completeMilestone() {
    }

    func calculateProgress() -> Double {
        /// Returns progress percentage (range of 0.0 to 1.0)
        ///
        if items.isEmpty { return 0.0 }

        let quantity = items.count

        let completed = items.reduce(0, { accumulator, value in
            if value.complete { return accumulator + 1 }

            return accumulator
        })

        let progress = Double(completed) / Double(quantity)

        let progressRounded3Decimals = Double(round(1000 * progress) / 1000)

        return progressRounded3Decimals
    }

    func addItem(_ newItem: NodeListItem) {
        items.append(newItem)
    }

    func getSuccessorsContour() -> LevelContour? {
        if sortedSuccessors.isEmpty { return nil }

        var leftNode = sortedSuccessors.first!
        var rightNode = sortedSuccessors.first!

        for node in sortedSuccessors {
            if node.coordinates.x < leftNode.coordinates.x {
                leftNode = node
            }

            if node.coordinates.x > rightNode.coordinates.x {
                rightNode = node
            }
        }

        return LevelContour(leftNode: leftNode, rightNode: rightNode)
    }

    init(progressTree: ProgressTree? = nil, unit: String, amount: Double, complete: Bool, progressiveQuest: Bool, name: String, emojiIcon: String, items: [NodeListItem], completionHistory: [ItemCompletionRecord]) {
        self.progressTree = progressTree
        self.unit = unit
        self.amount = amount
        self.complete = complete
        self.progressiveQuest = progressiveQuest
        self.name = name
        self.items = items
        self.completionHistory = completionHistory
        self.emojiIcon = emojiIcon
        repeatTimesToComplete = 1
        layer = -1
        coordinates = .zero
        successors = []
        parent = nil
        additionalParents = []
        orderKey = Int(Date().timeIntervalSince1970)

        let color: Color = progressTree == nil ? .green : progressTree!.color
        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }

    init(progressTree: ProgressTree? = nil, name: String, emojiIcon: String, parent: TreeNode? = nil) {
        self.progressTree = progressTree
        unit = ""
        amount = 0.0
        complete = false
        progressiveQuest = false
        self.name = name
        items = []
        completionHistory = []
        self.emojiIcon = emojiIcon
        layer = parent != nil ? parent!.layer + 1 : 1
        coordinates = .zero
        self.parent = parent
        additionalParents = []
        repeatTimesToComplete = 1

        orderKey = Int(Date().timeIntervalSince1970)

        let color: Color = progressTree == nil ? .green : progressTree!.color
        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }
}

struct NodeListItem: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var complete: Bool
    var createdAt: Date = Date.now
}
