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

    private static let SPACE_BETWEEN_NODES = 1

    /// Only used to force a specific order (because append order is not reliable on Swift Data)
    let orderKey: Int

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

    var progress: Double {
        let minProgress = 0.1

        if treeNodes.isEmpty || treeNodes.count == 1 { return minProgress }

        let treeNodesMinusRoot = treeNodes.filter({ $0.parent != nil })

        let completed = treeNodesMinusRoot.reduce(0, { accumulator, value in
            accumulator + value.calculateProgress()
        })

        let quantity = treeNodesMinusRoot.count

        let progress = Double(completed) / Double(quantity)

        let progressRounded3Decimals = Double(round(1000 * progress) / 1000)

        if progressRounded3Decimals < minProgress { return minProgress }

        return progressRounded3Decimals
    }

    @Relationship(deleteRule: .cascade, inverse: \TreeNode.progressTree)
    var treeNodes: [TreeNode] = []

    private func bfsPath(from start: TreeNode, to end: TreeNode) -> [TreeNode]? {
        var queue: [TreeNode] = [start]
        var visited: Set<PersistentIdentifier> = [start.id]
        var parentMap: [PersistentIdentifier: TreeNode] = [:]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if current.id == end.id {
                var path: [TreeNode] = []
                var node: TreeNode? = end

                while node != nil {
                    path.insert(node!, at: 0)
                    node = parentMap[node!.id]
                }

                return path
            }

            for neighbor in current.sortedSuccessors {
                if !visited.contains(neighbor.id) {
                    queue.append(neighbor)
                    visited.insert(neighbor.id)
                    parentMap[neighbor.id] = current
                }
            }
        }

        return nil
    }

    /// RETURNS CanvasSize : CGSize
    func updateNodeCoordinates(screenDimension: CGSize) -> CGSize {
        /// We use a copy because swift data doesn't let me sort the actual array
        var treeNodesCopy = treeNodes

        /// Assure that root node is the first node
        treeNodesCopy.sort(by: { n1, _ in n1.parent == nil })

        setNodesLayer(node: treeNodesCopy.first(where: { $0.parent == nil })!)

        initialCoordinates(node: treeNodesCopy.first(where: { $0.parent == nil })!)

        handleOverlap(&treeNodesCopy)

        normalizeCoordinates(&treeNodesCopy)

        scaleNodeCoord(&treeNodesCopy)

        let newCanvasSize = centerInCanvas(treeNodes: &treeNodesCopy, screenDimension: screenDimension)

        treeNodes = treeNodesCopy

        return newCanvasSize
    }

    /// Updates the layer value for each node
    private func setNodesLayer(node: TreeNode) {
        /// If root node
        if node.parent == nil {
            node.layer = 1
            node.coordinates.y = Double(1)
        } else {
            node.layer = node.parent!.layer + 1
            node.coordinates.y = Double(node.parent!.layer + 1)
        }

        node.sortedSuccessors.forEach { setNodesLayer(node: $0) }
    }

    func appendSubTreeToArray(_ node: TreeNode, _ arr: inout [TreeNode]) {
        arr.append(node)

        node.sortedSuccessors.forEach {
            appendSubTreeToArray($0, &arr)
        }
    }

    private func handleOverlap(_ treeNodes: inout [TreeNode]) {
        var overlap = true

        var limiter = 0
        let limiterBound = treeNodes.count

        repeat {
            let checkResult = checkOverlap(treeNodes)
            overlap = checkResult != nil

            if overlap == false { return }

            let overlapAmount: Double = checkResult!.2

            let (nodesToShiftByOverlapAmount, nodesToShiftByHalfOverlapAmount) = getNodesToShift(checkResult!, treeNodes: treeNodes)

            nodesToShiftByOverlapAmount.forEach { $0.coordinates.x += overlapAmount }

            nodesToShiftByHalfOverlapAmount.forEach { $0.coordinates.x += overlapAmount / 2 }

            limiter += 1
        } while overlap == true && limiter < limiterBound

        func checkOverlap(_ treeNodes: [TreeNode]) -> (PersistentIdentifier, PersistentIdentifier, Double)? {
            let contour = getTreeContour(treeNodes)

            var result: (PersistentIdentifier, PersistentIdentifier, Double)?

            for key in contour.keys.sorted(by: <) {
                let levelContours = contour[key]!

                let levelBiggestOverlap = getLevelBiggestOverlap(levelContours)

                let updateOverlap = levelBiggestOverlap != nil && (result == nil || levelBiggestOverlap!.2 >= result!.2)

                if updateOverlap { result = levelBiggestOverlap! }
            }

            return result

            func getLevelBiggestOverlap(_ levelContours: [LevelContour]) -> (PersistentIdentifier, PersistentIdentifier, Double)? {
                var result: (PersistentIdentifier, PersistentIdentifier, Double)?

                for (index, contour) in levelContours.enumerated() {
                    /// If we are in the last contour skip it, getting out of the for loop
                    /// Because we compare the current contour with the next one
                    if index == levelContours.count - 1 { continue }

                    let nextContour = levelContours[index + 1]

                    /// Two nodes perfectly overlapping is poor spacing and not overlap
                    let isOverlap = contour.rightNode.coordinates.x > nextContour.leftNode.coordinates.x
                    let overlapAmount = Double(abs(contour.rightNode.coordinates.x - nextContour.leftNode.coordinates.x))

                    /// Two nodes can be either overlapping or they can have little space between them but not be overlapping, these are two different cases
                    let overlapCase = isOverlap && (result == nil || result!.2 < overlapAmount)

                    let spaceBetweenNodes = nextContour.leftNode.coordinates.x - contour.rightNode.coordinates.x
                    let poorSpacingCase = !overlapCase && spaceBetweenNodes < Double(ProgressTree.SPACE_BETWEEN_NODES) && (result == nil || result!.2 < spaceBetweenNodes)

                    if overlapCase == true { result = (contour.rightNode.id, nextContour.leftNode.id, overlapAmount) }

                    if poorSpacingCase == true { result = (contour.rightNode.id, nextContour.leftNode.id, 1 - spaceBetweenNodes) }
                }

                return result
            }
        }

        func getTreeContour(_ treeNodes: [TreeNode]) -> [Int: [LevelContour]] {
            /// The Int represents the layer
            /// There are multiple contours because many subtrees might be present in the same layer
            var contour: [Int: [LevelContour]] = [:]

            /// Initialize the contour dictionary
            treeNodes.forEach { contour[$0.layer] = [] }

            /// Necessary because swift data does not respect the order of the nodes...
            recursiveBuildContour(treeNodes.first(where: { $0.parent == nil })!)

            func recursiveBuildContour(_ node: TreeNode) {
                /// For the root node the only node in the contour is itself
                if node.parent == nil {
                    contour[node.layer] = [LevelContour(leftNode: node, rightNode: node)]
                }

                /// If the current node has successors, get their layer's contour
                if !node.successors.isEmpty { contour[node.layer + 1]!.insert(node.getSuccessorsContour()!, at: 0) }

                node.sortedSuccessors.forEach { recursiveBuildContour($0) }
            }

            /// We reverse the order of each level's contours because...it's backwards
            for levelContours in contour {
                contour[levelContours.key] = levelContours.value.reversed()
            }

            return contour
        }

        func getNodesToShift(_ checkResult: (PersistentIdentifier, PersistentIdentifier, Double), treeNodes: [TreeNode]) -> ([TreeNode], [TreeNode]) {
            let leftNodeInConflict = treeNodes.first(where: { $0.id == checkResult.0 })
            let rightNodeInConflict = treeNodes.first(where: { $0.id == checkResult.1 })

            let pathToLeftNodeInConflict = bfsPath(from: treeNodes[0], to: leftNodeInConflict!)
            let pathToRightNodeInConflict = bfsPath(from: treeNodes[0], to: rightNodeInConflict!)

            if pathToLeftNodeInConflict == nil || pathToLeftNodeInConflict!.isEmpty { return ([], []) }
            if pathToRightNodeInConflict == nil || pathToRightNodeInConflict!.isEmpty { return ([], []) }

            let lastCommonNode = findLastCommonNode(path1: pathToLeftNodeInConflict!, path2: pathToRightNodeInConflict!)

            if lastCommonNode == nil { return ([], []) }

            let lastCommonNodeSortedSuccessors = lastCommonNode!.sortedSuccessors

            ///
            /// For nodesToShiftByOverlapAmount acts as : firstChildrenToGetShifted
            /// For nodesToShiftByHalfOverlapAmount acts as : upperBoundNode
            ///
            let firstCommonNodeBetweenPathToRightNodeAndLastCommonNode = firstCommonElement(array1: pathToRightNodeInConflict!, array2: lastCommonNodeSortedSuccessors)
            ///
            /// Get nodes to shift by overlap amount
            ///
            var nodesToShiftByOverlapAmount: [TreeNode] = []

            if firstCommonNodeBetweenPathToRightNodeAndLastCommonNode != nil {
                let n = lastCommonNodeSortedSuccessors.firstIndex(where: { $0.id == firstCommonNodeBetweenPathToRightNodeAndLastCommonNode!.id })

                if n != nil {
                    for i in n! ... lastCommonNodeSortedSuccessors.count - 1 {
                        let item = lastCommonNodeSortedSuccessors[i]

                        appendSubTreeToArray(item, &nodesToShiftByOverlapAmount)
                    }
                }
            }

            ///
            /// Get nodes to shift by half overlap amount
            ///
            var nodesToShiftByHalfOverlapAmount: [TreeNode] = []

            let lowerBoundNode = firstCommonElement(array1: pathToLeftNodeInConflict!, array2: lastCommonNodeSortedSuccessors)

            if !(lowerBoundNode == nil && firstCommonNodeBetweenPathToRightNodeAndLastCommonNode == nil) {
                let lowerBound = lastCommonNodeSortedSuccessors.firstIndex(where: { $0.id == lowerBoundNode!.id })
                let upperBound = lastCommonNodeSortedSuccessors.firstIndex(where: { $0.id == firstCommonNodeBetweenPathToRightNodeAndLastCommonNode!.id })

                if !(lowerBound == nil && upperBound == nil) {
                    /// Get nodes from layer 1 to last common node layer
                    treeNodes.forEach {
                        if $0.layer <= lastCommonNode!.layer { nodesToShiftByHalfOverlapAmount.append($0) }
                    }

                    if (upperBound! - lowerBound!) > 1 {
                        for index in lowerBound! + 1 ... upperBound! - 1 {
                            appendSubTreeToArray(lastCommonNodeSortedSuccessors[index], &nodesToShiftByHalfOverlapAmount)
                        }
                    }
                }
            }

            return (nodesToShiftByOverlapAmount, nodesToShiftByHalfOverlapAmount)
        }

        func findLastCommonNode(path1: [TreeNode], path2: [TreeNode]) -> TreeNode? {
            var lastCommonNode: TreeNode?

            let minLength = min(path1.count, path2.count)

            for i in 0 ..< minLength {
                if path1[i].id == path2[i].id {
                    lastCommonNode = path1[i]
                } else {
                    break
                }
            }

            return lastCommonNode
        }
    }

    /// Assigns coordinates based on their parent ignoring overlap
    private func initialCoordinates(node: TreeNode) {
        /// A node sets its successors's coordinates
        /// With itself aligned above them

        /// If root node
        if node.layer == 1 {
            node.coordinates.x = 0
        }

        /// The width of the successor layer
        let successorsWidth = Double(ProgressTree.SPACE_BETWEEN_NODES * (node.successors.count - 1))

        let sortedSuccessors = node.sortedSuccessors

        for (index, successor) in sortedSuccessors.enumerated() {
            successor.coordinates.x = node.coordinates.x + Double(index * ProgressTree.SPACE_BETWEEN_NODES) - successorsWidth / 2
        }

        sortedSuccessors.forEach { initialCoordinates(node: $0) }
    }

    /// Makes sure all coordinates are positive
    private func normalizeCoordinates(_ treeNodes: inout [TreeNode]) {
        var minX: Double?
        var minY: Double?

        for node in treeNodes {
            if minX == nil || node.coordinates.x < minX! { minX = node.coordinates.x }
            if minY == nil || node.coordinates.y < minY! { minY = node.coordinates.y }
        }

        for node in treeNodes {
            if minX! < 0 {
                node.coordinates.x = node.coordinates.x + abs(minX!)
            }

            if minY! < 0 {
                node.coordinates.y = node.coordinates.y + abs(minY!)
            }
        }
    }

    private func scaleNodeCoord(_ treeNodes: inout [TreeNode]) {
        let horizontalDistanceBetweenNodes = 150.0
        let distanceBetweenLayers = 150.0

        for node in treeNodes {
            node.coordinates.x = node.coordinates.x * horizontalDistanceBetweenNodes

            /// We subtract 1 because we want the root's y coord at 0. The initial layer is 1 and the y coord = layer
            node.coordinates.y = (node.coordinates.y - 1) * distanceBetweenLayers
        }
    }

    private func centerInCanvas(treeNodes: inout [TreeNode], screenDimension: CGSize) -> CGSize {
        let canvasDimensions = CanvasDimensions.getCanvasDimensions(screenDimension: screenDimension, treeNodes: treeNodes)

        let treeSize = ProgressTree.getTreeSize(treeNodes: treeNodes)

        let distanceToCenterHorizontally = (canvasDimensions.width - treeSize.width) / 2

        let distanceToCenterVertically = (canvasDimensions.height - treeSize.height) / 2

        for node in treeNodes {
            node.coordinates.x = node.coordinates.x + distanceToCenterHorizontally
            node.coordinates.y = node.coordinates.y + distanceToCenterVertically
        }

        return canvasDimensions
    }

    /// This function is static because using the nodes in memory (the instance of ProgressTree) causes issues because Swift Data
    /// Does not save nodes in the order they were inserted
    static func getTreeSize(treeNodes: [TreeNode]) -> CGSize {
        var minX: Double?
        var maxX: Double?
        var minY: Double?
        var maxY: Double?

        for node in treeNodes {
            if minX == nil || node.coordinates.x < minX! { minX = node.coordinates.x }
            if minY == nil || node.coordinates.y < minY! { minY = node.coordinates.y }

            if maxX == nil || node.coordinates.x > maxX! { maxX = node.coordinates.x }
            if maxY == nil || node.coordinates.y > maxY! { maxY = node.coordinates.y }
        }

        return CGSize(width: abs(maxX! - minX!), height: abs(maxY! - minY!))
    }

    init(name: String, emojiIcon: String, color: Color) {
        self.name = name

        self.emojiIcon = emojiIcon

        let colorArray = UIColor(color).cgColor.components!

        let red = colorArray[0]
        let green = colorArray[1]
        let blue = colorArray[2]

        orderKey = Int(Date.now.timeIntervalSince1970)

        colorR = Double(red)
        colorG = Double(green)
        colorB = Double(blue)
    }
}

struct LevelContour {
    var leftNode: TreeNode
    var rightNode: TreeNode
}

func firstCommonElement(array1: [TreeNode], array2: [TreeNode]) -> (TreeNode)? {
    var elementDict = [PersistentIdentifier: TreeNode]()

    // Store elements of the first array in the dictionary
    for element in array1 {
        elementDict[element.id] = element
    }

    // Find the first common element in the second array
    for element in array2 {
        if elementDict[element.id] != nil {
            return element
        }
    }

    return nil
}

struct CanvasDimensions {
    static func getCanvasDimensions(screenDimension: CGSize, treeNodes: [TreeNode]) -> CGSize {
        let screenHeight = screenDimension.height
        let screenWidth = screenDimension.width

        let treeSize: CGSize = ProgressTree.getTreeSize(treeNodes: treeNodes)

        let canvasWidth = getCanvasWidth(treeWidth: treeSize.width, padding: screenDimension.width)

        let canvasHeight = getCanvasHeight(treeHeight: treeSize.height, padding: screenDimension.height)

        return CGSize(width: canvasWidth, height: canvasHeight)

        func getCanvasWidth(treeWidth: Double, padding: Double) -> Double {
            let minCanvasWidth = treeWidth > screenWidth ? treeWidth : screenWidth

            return minCanvasWidth + padding
        }

        func getCanvasHeight(treeHeight: Double, padding: Double) -> Double {
            let minCanvasHeight = treeHeight > screenHeight ? treeHeight : screenHeight
            return minCanvasHeight + padding
        }
    }
}
