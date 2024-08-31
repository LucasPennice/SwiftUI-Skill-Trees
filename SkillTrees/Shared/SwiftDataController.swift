//
//  SwiftDataController.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 11/08/2024.
//

import Foundation
import SwiftData
import UIKit

@MainActor
class SwiftDataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([ProgressTree.self])
            let container = try ModelContainer(for: schema, configurations: config)

            let tree = ProgressTree(name: "New Skill", emojiIcon: "🆕", color: .green)

            let rootNode = TreeNode(name: "New Skill", emojiIcon: "🆕")
            rootNode.orderKey = 0
            container.mainContext.insert(rootNode)
            rootNode.progressTree = tree
            tree.treeNodes.append(rootNode)

            ///
            /// Child 1 and successors
            ///
            let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
            child1.orderKey = 1000
            container.mainContext.insert(child1)
            child1.progressTree = tree
            child1.parent = rootNode
            rootNode.successors.append(child1)
            tree.treeNodes.append(child1)

            let child11 = TreeNode(name: "Evaluate Current Skills and Knowledge", emojiIcon: "🔍", desc: "Complete a thorough self-assessment to identify your current knowledge and skills")
            child11.orderKey = 11000
            container.mainContext.insert(child11)
            child11.progressTree = tree
            child11.parent = child1
            child1.successors.append(child11)
            tree.treeNodes.append(child11)

            let child12 = TreeNode(name: "Set Clear Goals", emojiIcon: "📝", desc: "Define what you want to achieve in the short, medium, and long term. Examples include obtaining a degree, mastering a skill, or entering a specific career field")
            child12.orderKey = 12000
            container.mainContext.insert(child12)
            child12.progressTree = tree
            child12.parent = child1
            child1.successors.append(child12)
            tree.treeNodes.append(child12)

            ///
            /// Child 2 and successors
            ///
            let child2 = TreeNode(name: "Research and Explore Educational Pathways", emojiIcon: "👨🏻‍🔬")
            child2.orderKey = 2000
            container.mainContext.insert(child2)
            child2.progressTree = tree
            child2.parent = rootNode
            rootNode.successors.append(child2)
            tree.treeNodes.append(child2)

            let child21 = TreeNode(name: "Explore Fields of Interest", emojiIcon: "🔭", desc: "Research different fields and industries to find what excites you")
            child21.orderKey = 21000
            container.mainContext.insert(child21)
            child21.progressTree = tree
            child21.parent = child2
            child2.successors.append(child21)
            tree.treeNodes.append(child21)

            let child22 = TreeNode(name: "Identify Necessary Qualifications", emojiIcon: "🪪", desc: "Determine the qualifications or certifications needed in your chosen field")
            child22.orderKey = 22000
            container.mainContext.insert(child22)
            child22.progressTree = tree
            child22.parent = child2
            child2.successors.append(child22)
            tree.treeNodes.append(child22)

            let child23 = TreeNode(name: "Explore Learning Platforms", emojiIcon: "👩🏻‍🎓", desc: "Consider online courses (Coursera, edX, Udemy), traditional universities, community colleges, or vocational schools")
            child23.orderKey = 23000
            container.mainContext.insert(child23)
            child23.progressTree = tree
            child23.parent = child2
            child2.successors.append(child23)
            tree.treeNodes.append(child23)
            ///
            /// Child 3 and successors
            ///
            let child3 = TreeNode(name: "Develop a Learning Plan", emojiIcon: "🗓️")
            child3.orderKey = 3000
            container.mainContext.insert(child3)
            child3.progressTree = tree
            child3.parent = rootNode
            rootNode.successors.append(child3)
            tree.treeNodes.append(child3)

            let child31 = TreeNode(name: "Choose Your Courses", emojiIcon: "🎓", desc: "Select relevant courses, whether online, in-person, or a combination")
            child31.orderKey = 31000
            container.mainContext.insert(child31)
            child31.progressTree = tree
            child31.parent = child3
            child3.successors.append(child31)
            tree.treeNodes.append(child31)

            let child32 = TreeNode(name: "Create a Timeline", emojiIcon: "🗓️", desc: "Develop a realistic timeline for completing each course or milestone")
            child32.orderKey = 32000
            container.mainContext.insert(child32)
            child32.progressTree = tree
            child32.parent = child3
            child3.successors.append(child32)
            tree.treeNodes.append(child32)

            let child33 = TreeNode(name: "Budget Planning", emojiIcon: "💵", desc: "Calculate costs and explore financial aid, scholarships, or payment plans if needed")
            child33.orderKey = 33000
            container.mainContext.insert(child33)
            child33.progressTree = tree
            child33.parent = child3
            child3.successors.append(child33)
            tree.treeNodes.append(child33)

            ///
            /// Child 4 and successors
            ///
            let child4 = TreeNode(name: "Build Foundational Skills", emojiIcon: "🏗️")
            child4.orderKey = 4000
            container.mainContext.insert(child4)
            child4.progressTree = tree
            child4.parent = rootNode
            rootNode.successors.append(child4)
            tree.treeNodes.append(child4)

            let child41 = TreeNode(name: "Enroll in Basic Courses", emojiIcon: "👨🏾‍🎓", desc: "Start with introductory courses in your chosen field to build a solid foundation")
            child41.orderKey = 41000
            container.mainContext.insert(child41)
            child41.progressTree = tree
            child41.parent = child4
            child4.successors.append(child41)
            tree.treeNodes.append(child41)

            let child42 = TreeNode(name: "Focus on Core Competencies", emojiIcon: "🧱", desc: "Prioritize learning core skills that are crucial for advanced studies")
            child42.orderKey = 42000
            container.mainContext.insert(child42)
            child42.progressTree = tree
            child42.parent = child4
            child4.successors.append(child42)
            tree.treeNodes.append(child42)

            let child43 = TreeNode(name: "Practical Experience", emojiIcon: "👷🏼", desc: "Engage in internships, volunteer work, or part-time jobs related to your field")
            child43.orderKey = 43000
            container.mainContext.insert(child43)
            child43.progressTree = tree
            child43.parent = child4
            child4.successors.append(child43)
            tree.treeNodes.append(child43)

            ///
            /// Child 5 and successors
            ///
            let child5 = TreeNode(name: "Specialization and Advanced Learning", emojiIcon: "🧠")
            child5.orderKey = 5000
            container.mainContext.insert(child5)
            child5.progressTree = tree
            child5.parent = rootNode
            rootNode.successors.append(child5)
            tree.treeNodes.append(child5)

            let child51 = TreeNode(name: "Enroll in Specialized Programs", emojiIcon: "😎", desc: "After mastering the basics, move on to more specialized courses or certifications")
            child51.orderKey = 51000
            container.mainContext.insert(child51)
            child51.progressTree = tree
            child51.parent = child5
            child5.successors.append(child51)
            tree.treeNodes.append(child51)

            let child52 = TreeNode(name: "Network and Mentorship", emojiIcon: "🌐", desc: "Connect with professionals in the field, attend workshops, and seek mentorship opportunities")
            child52.orderKey = 52000
            container.mainContext.insert(child52)
            child52.progressTree = tree
            child52.parent = child5
            child5.successors.append(child52)
            tree.treeNodes.append(child52)

            let child53 = TreeNode(name: "Real-World Projects", emojiIcon: "🛠️", desc: "Apply your knowledge through capstone projects, internships, or research projects")
            child53.orderKey = 53000
            container.mainContext.insert(child53)
            child53.progressTree = tree
            child53.parent = child5
            child5.successors.append(child53)
            tree.treeNodes.append(child53)

            ///
            /// Child 6 and successors
            ///
            let child6 = TreeNode(name: "Continuous Learning and Professional Development", emojiIcon: "👨🏽‍🏭")
            child6.orderKey = 6000
            container.mainContext.insert(child6)
            child6.progressTree = tree
            child6.parent = rootNode
            rootNode.successors.append(child6)
            tree.treeNodes.append(child6)

            let child61 = TreeNode(name: "Stay Updated", emojiIcon: "🆕", desc: "Follow industry trends, attend seminars, and continue taking courses to keep your knowledge current")
            child61.orderKey = 61000
            container.mainContext.insert(child61)
            child61.progressTree = tree
            child61.parent = child6
            child6.successors.append(child61)
            tree.treeNodes.append(child61)

            let child62 = TreeNode(name: "Advanced Certifications or Degrees", emojiIcon: "🧑🏻‍🎓", desc: "Consider pursuing advanced degrees or certifications as your career progresses")
            child62.orderKey = 62000
            container.mainContext.insert(child62)
            child62.progressTree = tree
            child62.parent = child6
            child6.successors.append(child62)
            tree.treeNodes.append(child62)

            let child63 = TreeNode(name: "Lifelong Learning", emojiIcon: "👴🏼", desc: "Make learning a continuous part of your life to adapt to changes and advancements in your field")
            child63.orderKey = 63000
            container.mainContext.insert(child63)
            child63.progressTree = tree
            child63.parent = child6
            child6.successors.append(child63)
            tree.treeNodes.append(child63)

            ///
            /// Child 7 and successors
            ///
            let child7 = TreeNode(name: "Review and Adjust", emojiIcon: "🔍")
            child7.orderKey = 7000
            container.mainContext.insert(child7)
            child7.progressTree = tree
            child7.parent = rootNode
            rootNode.successors.append(child7)
            tree.treeNodes.append(child7)

            let child71 = TreeNode(name: "Regularly Review Goals", emojiIcon: "🔁", desc: "Assess your progress every few months and adjust your roadmap as needed")
            child71.orderKey = 71000
            container.mainContext.insert(child71)
            child71.progressTree = tree
            child71.parent = child7
            child7.successors.append(child71)
            tree.treeNodes.append(child71)

            let child72 = TreeNode(name: "Seek Feedback", emojiIcon: "🗣️", desc: "Regularly seek feedback from mentors, peers, and professionals to refine your skills and approach")
            child72.orderKey = 72000
            container.mainContext.insert(child72)
            child72.progressTree = tree
            child72.parent = child7
            child7.successors.append(child72)
            tree.treeNodes.append(child72)

            let child73 = TreeNode(name: "Celebrate Milestones", emojiIcon: "🍾", desc: "Acknowledge and celebrate your achievements to stay motivated")
            child73.orderKey = 73000
            container.mainContext.insert(child73)
            child73.progressTree = tree
            child73.parent = child7
            child7.successors.append(child73)
            tree.treeNodes.append(child73)

            _ = tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
