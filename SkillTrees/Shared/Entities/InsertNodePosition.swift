//
//  InsertNodePosition.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 20/08/2024.
//

import Foundation
import SwiftData

struct InsertNodePosition: Identifiable {
    var id = UUID()
    var parentId: PersistentIdentifier
    var orderKey: Double
    var coordinates: CGPoint
    var size: CGSize

    static var defaultSize = CGSize(width: TreeNodeView.defaultSize, height: 45)

    static func getTreeInsertPositions(treeNodes: [TreeNode]) -> [InsertNodePosition] {
        var result: [InsertNodePosition] = []

        for node in treeNodes {
            let isRootNode = node.parent == nil

            if !isRootNode {
                ///
                /// Insert Node Position Above a node
                ///
//                result.append(
//                    InsertNodePosition(
//                        parentId: node.parent!.persistentModelID,
//                        orderKey: node.orderKey,
//                        coordinates: CGPoint(x: node.coordinates.x, y: node.coordinates.y - InsertNodePosition.defaultSize.height),
//                        size: InsertNodePosition.defaultSize)
//                )

                ///
                /// Insert Node Position below a node if no successors
                ///
                if node.successors.isEmpty {
                    result.append(
                        InsertNodePosition(
                            parentId: node.persistentModelID,
                            orderKey: TreeNode.generateOrderKey(),
                            coordinates: CGPoint(x: node.coordinates.x, y: node.coordinates.y + InsertNodePosition.defaultSize.height),
                            size: InsertNodePosition.defaultSize)
                    )
                }
            }

            let lastSuccessorIdx = node.successors.count - 1

            node.sortedSuccessors.enumerated().forEach { idx, successor in
                let isLastSuccessorIdx = lastSuccessorIdx == idx

                ///
                /// Insert Node Position left of node
                ///
                if idx == 0 {
                    result.append(
                        InsertNodePosition(
                            parentId: node.persistentModelID,
                            orderKey: successor.orderKey / 2,
                            coordinates: CGPoint(x: successor.coordinates.x - InsertNodePosition.defaultSize.width, y: successor.coordinates.y),
                            size: InsertNodePosition.defaultSize)
                    )
                }
                ///
                /// Insert Node Position right of node
                ///
                let rightInsertNodePositionWidth = isLastSuccessorIdx ?InsertNodePosition.defaultSize.width : node.sortedSuccessors[idx + 1].coordinates.x - successor.coordinates.x - TreeNodeView.defaultSize

                result.append(
                    InsertNodePosition(
                        parentId: node.persistentModelID,
                        orderKey: isLastSuccessorIdx ? successor.orderKey * 1.5 : (successor.orderKey + node.sortedSuccessors[idx + 1].orderKey) / 2,
                        coordinates: CGPoint(x: successor.coordinates.x + rightInsertNodePositionWidth / 2 + TreeNodeView.defaultSize / 2, y: successor.coordinates.y),
                        size: CGSize(width: rightInsertNodePositionWidth, height: InsertNodePosition.defaultSize.height))
                )
            }
        }

        return result
    }
}
