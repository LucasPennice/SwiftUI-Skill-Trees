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

//    private static let SPACE_BETWEEN_NODES = 1

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
//    {
//        didSet {
//            updateNodeCoordinates()
//        }
//    }
//
//    private func bfsPath(from start: TreeNode, to end: TreeNode) -> [TreeNode]? {
//        var queue: [TreeNode] = [start]
//        var visited: Set<UUID> = [start.id]
//        var parentMap: [UUID: TreeNode] = [:]
//
//        while !queue.isEmpty {
//            let current = queue.removeFirst()
//
//            if current.id == end.id {
//                var path: [TreeNode] = []
//                var node: TreeNode? = end
//
//                while node != nil {
//                    path.insert(node!, at: 0)
//                    node = parentMap[node!.id]
//                }
//
//                return path
//            }
//
//            for neighbor in current.successors {
//                if !visited.contains(neighbor.id) {
//                    queue.append(neighbor)
//                    visited.insert(neighbor.id)
//                    parentMap[neighbor.id] = current
//                }
//            }
//        }
//
//        return nil
//    }
//
//    func updateNodeCoordinates() {
//        /// Sort nodes by layers, smaller layers first
//        treeNodes.sort(by: { $0.layer < $1.layer })
//
//        setNodesLayer()
//
//        initialCoordinates(node: treeNodes[0])
//
//        handleOverlap()
//    }
//
//    /// Updates the layer value for each node
//    private func setNodesLayer() {
//        treeNodes.forEach { node in
//            let isRootNode = node.parent == nil
//
//            /// For each source node it sets it to layer 1
//            if isRootNode {
//                node.layer = 1
//                node.coordinates.y = Double(node.layer)
//            } else {
//                node.layer = node.parent!.layer + 1
//                /// We update the node's Y coordinate to match that of its layer
//                node.coordinates.y = Double(node.layer)
//            }
//        }
//    }
//
//    private func handleOverlap() {
//        var overlap = true
//
//        var limiter = 0
//        let limiterBound = treeNodes.last!.layer * 2
//
//        repeat {
//            let checkResult = checkOverlap()
//            overlap = checkResult != nil
//
//            if overlap == false { return }
//
//            let overlapAmount: Double = checkResult!.2
//
//            let nodesToShiftByOverlapAmount = getNodesToShiftByOverlapAmount(checkResult!)
//
//            let nodesToShiftByHalfOverlapAmount = getNodesToShiftByHalfOverlapAmount(checkResult!)
//
//            nodesToShiftByOverlapAmount.forEach { $0.coordinates.x += overlapAmount }
//
//            nodesToShiftByHalfOverlapAmount.forEach { $0.coordinates.x += overlapAmount / 2 }
//
//            limiter += 1
//        } while overlap == true && limiter < limiterBound
//
//        func checkOverlap() -> (UUID, UUID, Double)? {
//            let contour = getTreeContour()
//
//            var result: (UUID, UUID, Double)?
//
//            for item in contour {
//                let levelContours = item.value
//
//                let levelBiggestOverlap = getLevelBiggestOverlap(levelContours)
//
//                let updateOverlap = levelBiggestOverlap != nil && (result == nil || levelBiggestOverlap!.2 >= result!.2)
//
//                if updateOverlap { result = levelBiggestOverlap! }
//            }
//
//            return result
//
//            func getLevelBiggestOverlap(_ levelContours: [LevelContour]) -> (UUID, UUID, Double)? {
//                var result: (UUID, UUID, Double)?
//
//                for (index, contour) in levelContours.enumerated() {
//                    /// If we are in the last contour skip it, getting out of the for loop
//                    /// Because we compare the current contour with the next one
//                    if index == levelContours.count - 1 { continue }
//
//                    let nextContour = levelContours[index + 1]
//
//                    /// Two nodes perfectly overlapping is poor spacing and not overlap
//                    let isOverlap = contour.rightNode.coordinates.x > nextContour.leftNode.coordinates.x
//                    let overlapAmount = Double(abs(contour.rightNode.coordinates.x - nextContour.leftNode.coordinates.x))
//
//                    /// Two nodes can be either overlapping or they can have little space between them but not be overlapping, these are two different cases
//                    let overlapCase = isOverlap && (result == nil || result!.2 < overlapAmount)
//
//                    let spaceBetweenNodes = nextContour.leftNode.coordinates.x - contour.rightNode.coordinates.x
//                    let poorSpacingCase = !overlapCase && spaceBetweenNodes < Double(ProgressTree.SPACE_BETWEEN_NODES) && (result == nil || result!.2 < spaceBetweenNodes)
//
//                    if overlapCase == true { result = (contour.rightNode.id, nextContour.leftNode.id, overlapAmount) }
//
//                    if poorSpacingCase == true { result = (contour.rightNode.id, nextContour.leftNode.id, 1 - spaceBetweenNodes) }
//                }
//
//                return result
//            }
//        }
//
//        func getTreeContour() -> [Int: [LevelContour]] {
//            /// The Int represents the layer
//            /// There are multiple contours because many subtrees might be present in the same layer
//            var contour: [Int: [LevelContour]] = [:]
//
//            /// Initialize the contour dictionary
//            treeNodes.forEach { contour[$0.layer] = [] }
//
//            recursiveBuildContour(treeNodes[0])
//
//            func recursiveBuildContour(_ node: TreeNode) {
//                /// For the root node the only node in the contour is itself
//                if node.parent == nil {
//                    contour[node.layer] = [LevelContour(leftNode: node, rightNode: node)]
//                }
//
//                /// If the current node has successors, get their layer's contour
//                if !node.successors.isEmpty { contour[node.layer + 1]!.insert(node.getSuccessorsContour()!, at: 0) }
//
//                node.successors.forEach { recursiveBuildContour($0) }
//            }
//
//            return contour
//        }
//
//        func getNodesToShiftByOverlapAmount(_ checkResult: (UUID, UUID, Double)) -> [TreeNode] {
//            var result: [TreeNode] = []
//
//            let leftNodeInConflict = treeNodes.first(where: { $0.id == checkResult.0 })
//            let rightNodeInConflict = treeNodes.first(where: { $0.id == checkResult.1 })
//
//            let pathToLeftNodeInConflict = bfsPath(from: treeNodes[0], to: leftNodeInConflict!)
//            let pathToRightNodeInConflict = bfsPath(from: treeNodes[0], to: rightNodeInConflict!)
//
//            if pathToLeftNodeInConflict == nil || pathToLeftNodeInConflict!.isEmpty { return [] }
//            if pathToRightNodeInConflict == nil || pathToRightNodeInConflict!.isEmpty { return [] }
//
//            let lastCommonNode = findLastCommonNode(path1: pathToLeftNodeInConflict!, path2: pathToRightNodeInConflict!)
//
//            if lastCommonNode == nil { return [] }
//
//            let lastChildrenToGetShifted = firstCommonElement(array1: pathToRightNodeInConflict!, array2: lastCommonNode!.successors)
//
//            if lastChildrenToGetShifted == nil { return [] }
//
//            let n = lastCommonNode!.successors.firstIndex(where: { $0.id == lastChildrenToGetShifted!.id })
//
//            if n == nil { return [] }
//
//            for i in 0 ... n! {
//                let item = lastCommonNode!.successors[i]
//
//                appendGraphToArray(item, &result)
//            }
//
//            return result
//        }
//
//        func appendGraphToArray(_ node: TreeNode, _ arr: inout [TreeNode]) {
//            arr.append(node)
//
//            node.successors.forEach {
//                appendGraphToArray($0, &arr)
//            }
//        }
//
//        func getNodesToShiftByHalfOverlapAmount(_ checkResult: (UUID, UUID, Double)) -> [TreeNode] {
//            var result: [TreeNode] = []
//
//            let leftNodeInConflict = treeNodes.first(where: { $0.id == checkResult.0 })
//            let rightNodeInConflict = treeNodes.first(where: { $0.id == checkResult.1 })
//
//            let pathToLeftNodeInConflict = bfsPath(from: treeNodes[0], to: leftNodeInConflict!)
//            let pathToRightNodeInConflict = bfsPath(from: treeNodes[0], to: rightNodeInConflict!)
//
//            if pathToLeftNodeInConflict == nil || pathToLeftNodeInConflict!.isEmpty { return [] }
//            if pathToRightNodeInConflict == nil || pathToRightNodeInConflict!.isEmpty { return [] }
//
//            let lastCommonNode = findLastCommonNode(path1: pathToLeftNodeInConflict!, path2: pathToRightNodeInConflict!)
//
//            if lastCommonNode == nil { return [] }
//
//            let lowerBoundNode = firstCommonElement(array1: pathToLeftNodeInConflict!, array2: lastCommonNode!.successors)
//            let upperBoundNode = firstCommonElement(array1: pathToRightNodeInConflict!, array2: lastCommonNode!.successors)
//
//            if lowerBoundNode == nil && upperBoundNode == nil { return [] }
//
//            let lowerBound = lastCommonNode!.successors.firstIndex(where: { $0.id == lowerBoundNode!.id })
//            let upperBound = lastCommonNode!.successors.firstIndex(where: { $0.id == upperBoundNode!.id })
//
//            if lowerBound == nil && upperBound == nil { return [] }
//
//            /// Get nodes from layer 1 to last common node layer
//            treeNodes.forEach {
//                if $0.layer <= lastCommonNode!.layer { result.append($0) }
//            }
//
//            if (upperBound! - lowerBound!) > 1 {
//                for index in lowerBound! + 1 ... upperBound! - 1 {
//                    appendGraphToArray(lastCommonNode!.successors[index], &result)
//                }
//            }
//
//            return result
//        }
//
//        func findLastCommonNode(path1: [TreeNode], path2: [TreeNode]) -> TreeNode? {
//            var lastCommonNode: TreeNode?
//
//            let minLength = min(path1.count, path2.count)
//
//            for i in 0 ..< minLength {
//                if path1[i].id == path2[i].id {
//                    lastCommonNode = path1[i]
//                } else {
//                    break
//                }
//            }
//
//            return lastCommonNode
//        }
//    }
//
//    /// Assigns coordinates based on their parent ignoring overlap
//    private func initialCoordinates(node: TreeNode) {
//        /// A node sets its successors's coordinates
//        /// With itself aligned above them
//
//        /// If root node
//        if node.layer == 1 {
//            node.coordinates.x = 0
//        }
//
//        /// The width of the successor layer
//        let successorsWidth = Double(ProgressTree.SPACE_BETWEEN_NODES * (node.successors.count - 1))
//
//        for (index, successor) in node.successors.enumerated() {
//            successor.coordinates.x = node.coordinates.x + Double(index * ProgressTree.SPACE_BETWEEN_NODES) - successorsWidth / 2
//        }
//
//        node.successors.forEach { initialCoordinates(node: $0) }
//    }

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
//
//struct LevelContour {
//    var leftNode: TreeNode
//    var rightNode: TreeNode
//}
//
//func firstCommonElement(array1: [TreeNode], array2: [TreeNode]) -> (TreeNode)? {
//    var elementDict = [UUID: TreeNode]()
//
//    // Store elements of the first array in the dictionary
//    for element in array1 {
//        elementDict[element.id] = element
//    }
//
//    // Find the first common element in the second array
//    for element in array2 {
//        if elementDict[element.id] != nil {
//            return element
//        }
//    }
//
//    return nil
//}
