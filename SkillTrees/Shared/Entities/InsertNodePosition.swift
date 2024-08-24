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
    var orderKey: Int
    var coordinates: CGPoint
    var size: CGSize

//    static var defaultSize = CGSize(width: 10, height: 10)
    static var defaultSize = CGSize(width: TreeNodeView.defaultSize, height: 45)

    static func getTreeInsertPositions(treeNodes: [TreeNode]) -> [InsertNodePosition] {
        var result: [InsertNodePosition] = []

        for node in treeNodes {
            let isRootNode = node.parent == nil

            if !isRootNode {
                ///
                /// Insert Node Position Above a node
                ///
                result.append(
                    InsertNodePosition(
                        parentId: node.parent!.persistentModelID,
                        orderKey: node.orderKey,
                        coordinates: CGPoint(x: node.coordinates.x, y: node.coordinates.y - InsertNodePosition.defaultSize.height),
                        size: InsertNodePosition.defaultSize)
                )
                ///
                /// Insert Node Position left of node
                ///
                #warning("definir orderkey")
                result.append(
                    InsertNodePosition(
                        parentId: node.parent!.persistentModelID,
                        orderKey: node.orderKey,
                        coordinates: CGPoint(x: node.coordinates.x - InsertNodePosition.defaultSize.width, y: node.coordinates.y),
                        size: InsertNodePosition.defaultSize)
                )
                ///
                /// Insert Node Position right of node
                ///
                result.append(
                    InsertNodePosition(
                        parentId: node.parent!.persistentModelID,
                        orderKey: node.orderKey,
                        coordinates: CGPoint(x: node.coordinates.x + InsertNodePosition.defaultSize.width, y: node.coordinates.y),
                        size: InsertNodePosition.defaultSize)
                )
                ///
                /// Insert Node Position below a node if no successors
                ///
                if node.successors.isEmpty {
                    result.append(
                        InsertNodePosition(
                            parentId: node.persistentModelID,
                            orderKey: node.orderKey,
                            coordinates: CGPoint(x: node.coordinates.x, y: node.coordinates.y + InsertNodePosition.defaultSize.height),
                            size: InsertNodePosition.defaultSize)
                    )
                }
            }
        }

        return result
    }
}
