//
//  TreeNode.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

enum TreeNodeType {
    case List
    case Default
    case Repeat
    case Progressive
}

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

    var desc: String?

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
    var orderKey: Double

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
    private(set) var progressive: Bool = false
    var unit: String = ""
    var amount: Double = 0.0
    var targetAmount: Double = 0.0
    @Relationship(deleteRule: .cascade, inverse: \ItemCompletionRecord.treeNode)
    var completionHistory: [ItemCompletionRecord] = []
    ///

    func enableProgressiveQuest() { progressive = true }

    var items: [NodeListItem] = []

    /// Number of times the action has to be performed to complete the node
    var repeatTimesToComplete: Int

    func undoCompletion(_ date: Date = .now) {
        //
    }

    func findFirstIncompleteNode(_ node: TreeNode?) -> TreeNode? {
        guard let node = node else { return nil }

        // If the node is incomplete and either it has no successors, or all successors are complete
        if !node.complete && (node.successors.isEmpty || node.successors.allSatisfy { $0.complete }) {
            return node
        }

        // Traverse successors
        for successor in node.sortedSuccessors {
            if let found = findFirstIncompleteNode(successor) {
                return found
            }
        }

        return nil
    }

    func progressMilestone() {
        let nodeType = getNodeType()

        /// Record the completion event regardless of the node type
        completionHistory.append(ItemCompletionRecord(date: .now, unit: unit, amount: amount, treeNode: self))

        if nodeType == .Default { return complete = true }

        if nodeType == .List && !items.contains(where: { $0.complete == false }) { return complete = true }

        if nodeType == .Progressive && amount >= targetAmount { return complete = true }

        if nodeType == .Repeat && completionHistory.count > repeatTimesToComplete { return complete = true }
    }

    func calculateProgress() -> Double {
        ///
        /// Returns progress percentage (range of 0.0 to 1.0)
        ///

        let nodeType = getNodeType()

        if nodeType == .Default { return complete == true ? 1.0 : 0.0 }

        var progress: Double = 0.0

        if nodeType == .List {
            let completed = items.reduce(0, { accumulator, value in
                if value.complete { return accumulator + 1 }

                return accumulator
            })

            let quantity = items.count

            progress = Double(completed) / Double(quantity)
        }

        if nodeType == .Progressive {
            if amount > targetAmount { return 1.0 }

            progress = amount / targetAmount
        }

        if nodeType == .Repeat {
            let repeatedTimes = completionHistory.count

            if repeatedTimes > repeatTimesToComplete { return 1.0 }

            progress = Double(repeatedTimes) / Double(repeatTimesToComplete)
        }

        let progressRounded3Decimals = Double(round(1000 * progress) / 1000)

        return progressRounded3Decimals
    }

    func addItem(_ newItem: NodeListItem) {
        items.append(newItem)
    }

    func getNodeType() -> TreeNodeType {
        if progressive { return .Progressive }
        if !items.isEmpty { return .List }
        if repeatTimesToComplete > 1 { return .Repeat }
        return .Default
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

    init(progressTree: ProgressTree? = nil, unit: String, amount: Double, complete: Bool, progressiveQuest: Bool, name: String, emojiIcon: String, items: [NodeListItem], completionHistory: [ItemCompletionRecord], desc: String? = nil) {
        self.progressTree = progressTree
        self.unit = unit
        self.amount = amount
        self.complete = complete
        progressive = progressiveQuest
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
        orderKey = TreeNode.generateOrderKey()
        self.desc = desc

        let color: Color = progressTree == nil ? .green : progressTree!.color
        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }

    init(progressTree: ProgressTree? = nil, name: String, emojiIcon: String, parent: TreeNode? = nil, desc: String? = nil) {
        self.progressTree = progressTree
        unit = ""
        amount = 0.0
        complete = false
        progressive = false
        self.name = name
        items = []
        completionHistory = []
        self.emojiIcon = emojiIcon
        layer = parent != nil ? parent!.layer + 1 : 1
        coordinates = .zero
        self.parent = parent
        additionalParents = []
        repeatTimesToComplete = 1
        self.desc = desc

        orderKey = TreeNode.generateOrderKey()

        let color: Color = progressTree == nil ? .green : progressTree!.color
        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }

    static func generateOrderKey() -> Double {
        return Double(Date().timeIntervalSince1970)
    }
}

struct NodeListItem: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var complete: Bool
    var createdAt: Date = Date.now
}
