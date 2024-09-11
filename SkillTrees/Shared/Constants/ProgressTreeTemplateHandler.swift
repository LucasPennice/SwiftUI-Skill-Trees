//
//  ProgressTreeTemplates.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 12/08/2024.
//
import Foundation
import SwiftData
import SwiftUI

struct TemplatePreview {
    var id: String
    var name: String
    var emojiIcon: String
    var color: Color
}

actor ProgressTreeTemplateHandler {
    var modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func backgroundInsertAddTemplate(_ templateIds: [String]) async throws {
        let modelContext = ModelContext(modelContainer)

        for templateId in templateIds {
            if templateId == "NEW_SKILL" {
                let tree = ProgressTree(name: "New Skill", emojiIcon: "🆕", color: .green)

                let rootNode = TreeNode(name: "New Skill", emojiIcon: "🆕")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Current Skills and Knowledge", emojiIcon: "🔍", desc: "Complete a thorough self-assessment to identify your current knowledge and skills")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Clear Goals", emojiIcon: "📝", desc: "Define what you want to achieve in the short, medium, and long term. Examples include obtaining a degree, mastering a skill, or entering a specific career field")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Research and Explore Educational Pathways", emojiIcon: "👨🏻‍🔬")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Explore Fields of Interest", emojiIcon: "🔭", desc: "Research different fields and industries to find what excites you")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Identify Necessary Qualifications", emojiIcon: "🪪", desc: "Determine the qualifications or certifications needed in your chosen field")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Explore Learning Platforms", emojiIcon: "👩🏻‍🎓", desc: "Consider online courses (Coursera, edX, Udemy), traditional universities, community colleges, or vocational schools")
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Develop a Learning Plan", emojiIcon: "🗓️")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Choose Your Courses", emojiIcon: "🎓", desc: "Select relevant courses, whether online, in-person, or a combination")
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Create a Timeline", emojiIcon: "🗓️", desc: "Develop a realistic timeline for completing each course or milestone")
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                let child33 = TreeNode(name: "Budget Planning", emojiIcon: "💵", desc: "Calculate costs and explore financial aid, scholarships, or payment plans if needed")
                child33.orderKey = 33000
                modelContext.insert(child33)
                child33.progressTree = tree
                child33.parent = child3
                child3.successors.append(child33)
                tree.treeNodes.append(child33)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Build Foundational Skills", emojiIcon: "🏗️")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Enroll in Basic Courses", emojiIcon: "👨🏾‍🎓", desc: "Start with introductory courses in your chosen field to build a solid foundation")
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Focus on Core Competencies", emojiIcon: "🧱", desc: "Prioritize learning core skills that are crucial for advanced studies")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                let child43 = TreeNode(name: "Practical Experience", emojiIcon: "👷🏼", desc: "Engage in internships, volunteer work, or part-time jobs related to your field")
                child43.orderKey = 43000
                modelContext.insert(child43)
                child43.progressTree = tree
                child43.parent = child4
                child4.successors.append(child43)
                tree.treeNodes.append(child43)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Specialization and Advanced Learning", emojiIcon: "🧠")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Enroll in Specialized Programs", emojiIcon: "😎", desc: "After mastering the basics, move on to more specialized courses or certifications")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Network and Mentorship", emojiIcon: "🌐", desc: "Connect with professionals in the field, attend workshops, and seek mentorship opportunities")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                let child53 = TreeNode(name: "Real-World Projects", emojiIcon: "🛠️", desc: "Apply your knowledge through capstone projects, internships, or research projects")
                child53.orderKey = 53000
                modelContext.insert(child53)
                child53.progressTree = tree
                child53.parent = child5
                child5.successors.append(child53)
                tree.treeNodes.append(child53)

                ///
                /// Child 6 and successors
                ///
                let child6 = TreeNode(name: "Continuous Learning and Professional Development", emojiIcon: "👨🏽‍🏭")
                child6.orderKey = 6000
                modelContext.insert(child6)
                child6.progressTree = tree
                child6.parent = rootNode
                rootNode.successors.append(child6)
                tree.treeNodes.append(child6)

                let child61 = TreeNode(name: "Stay Updated", emojiIcon: "🆕", desc: "Follow industry trends, attend seminars, and continue taking courses to keep your knowledge current")
                child61.orderKey = 61000
                modelContext.insert(child61)
                child61.progressTree = tree
                child61.parent = child6
                child6.successors.append(child61)
                tree.treeNodes.append(child61)

                let child62 = TreeNode(name: "Advanced Certifications or Degrees", emojiIcon: "🧑🏻‍🎓", desc: "Consider pursuing advanced degrees or certifications as your career progresses")
                child62.orderKey = 62000
                modelContext.insert(child62)
                child62.progressTree = tree
                child62.parent = child6
                child6.successors.append(child62)
                tree.treeNodes.append(child62)

                let child63 = TreeNode(name: "Lifelong Learning", emojiIcon: "👴🏼", desc: "Make learning a continuous part of your life to adapt to changes and advancements in your field")
                child63.orderKey = 63000
                modelContext.insert(child63)
                child63.progressTree = tree
                child63.parent = child6
                child6.successors.append(child63)
                tree.treeNodes.append(child63)

                ///
                /// Child 7 and successors
                ///
                let child7 = TreeNode(name: "Review and Adjust", emojiIcon: "🔍")
                child7.orderKey = 7000
                modelContext.insert(child7)
                child7.progressTree = tree
                child7.parent = rootNode
                rootNode.successors.append(child7)
                tree.treeNodes.append(child7)

                let child71 = TreeNode(name: "Regularly Review Goals", emojiIcon: "🔁", desc: "Assess your progress every few months and adjust your roadmap as needed")
                child71.orderKey = 71000
                modelContext.insert(child71)
                child71.progressTree = tree
                child71.parent = child7
                child7.successors.append(child71)
                tree.treeNodes.append(child71)

                let child72 = TreeNode(name: "Seek Feedback", emojiIcon: "🗣️", desc: "Regularly seek feedback from mentors, peers, and professionals to refine your skills and approach")
                child72.orderKey = 72000
                modelContext.insert(child72)
                child72.progressTree = tree
                child72.parent = child7
                child7.successors.append(child72)
                tree.treeNodes.append(child72)

                let child73 = TreeNode(name: "Celebrate Milestones", emojiIcon: "🍾", desc: "Acknowledge and celebrate your achievements to stay motivated")
                child73.orderKey = 73000
                modelContext.insert(child73)
                child73.progressTree = tree
                child73.parent = child7
                child7.successors.append(child73)
                tree.treeNodes.append(child73)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "COLLEGE" {
                let tree = ProgressTree(name: "College", emojiIcon: "👨🏼‍🎓", color: .blue)

                let rootNode = TreeNode(name: "College", emojiIcon: "👨🏼‍🎓")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Your Interests and Strengths", emojiIcon: "🔍", desc: "Assess your academic interests, career goals, and the type of college experience you want")
                child11.items = [
                    NodeListItem(name: "Assess academic interests", complete: false),
                    NodeListItem(name: "Assess career goals", complete: false),
                    NodeListItem(name: "Assess college experience", complete: false)]
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Academic and Career Goals", emojiIcon: "📝", desc: "Set clear, actionable goals for your college education, such as the field of study, the type of degree, and personal development objectives")
                child12.items = [
                    NodeListItem(name: "Define field of study", complete: false),
                    NodeListItem(name: "Define type of degree", complete: false),
                    NodeListItem(name: "Define personal development objectives", complete: false)]
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Research and Select Colleges", emojiIcon: "👨🏻‍🔬")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Explore Degree Options", emojiIcon: "🔭", desc: "Research potential degree programs (Associate, Bachelor’s, Master’s, Doctorate) and the fields of study that align with your interests")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Investigate Institutions", emojiIcon: "🏫", desc: "Look into universities, colleges, and technical schools offering your desired programs. Visit campuses, attend college fairs, and speak with current students or alumni to gather insights. Consider factors like location, reputation, cost, and available resources")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Understand Admission Requirements", emojiIcon: "👩🏻‍🎓", desc: "Review the prerequisites, such as GPA, standardized test scores (SAT, ACT, GRE, etc.), and application materials needed for each program.")
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Application Process", emojiIcon: "📫")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Standardized Testing", emojiIcon: "🧪", desc: "If required, register for and prepare for standardized tests. Consider taking prep courses if necessary")
                child31.items = [
                    NodeListItem(name: "Register to standardized tests", complete: false),
                    NodeListItem(name: "Prepare for standardized tests", complete: false),
                ]
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Gather Application Materials", emojiIcon: "🧱", desc: "Prepare your transcripts, letters of recommendation, personal statement, and other necessary documents")
                child32.items = [
                    NodeListItem(name: "Prepare transcripts", complete: false),
                    NodeListItem(name: "Prepare letters of recommendation", complete: false),
                    NodeListItem(name: "Prepare personal statement", complete: false),
                    NodeListItem(name: "Prepare other", complete: false),
                ]
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                let child33 = TreeNode(name: "Apply to Programs", emojiIcon: "📨", desc: "Submit applications to your selected schools, paying close attention to deadlines and application requirements.")
                child33.orderKey = 33000
                modelContext.insert(child33)
                child33.progressTree = tree
                child33.parent = child3
                child3.successors.append(child33)
                tree.treeNodes.append(child33)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Acceptance and Preparation", emojiIcon: "🏃🏽‍♀️‍➡️")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Acceptance and Enrollment", emojiIcon: "👨🏾‍🎓", desc: "Once accepted, confirm your enrollment and complete any required paperwork")
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Attend Orientation", emojiIcon: "🧑🏻‍🏫", desc: "Participate in orientation sessions to familiarize yourself with the campus, resources, and academic expectations")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                let child43 = TreeNode(name: "Course Registration", emojiIcon: "👷🏼", desc: "Register for your first semester courses, ensuring you meet prerequisites and degree requirements")
                child43.orderKey = 43000
                modelContext.insert(child43)
                child43.progressTree = tree
                child43.parent = child4
                child4.successors.append(child43)
                tree.treeNodes.append(child43)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Foundational Coursework", emojiIcon: "1️⃣")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "General Education Requirements", emojiIcon: "😎", desc: "Complete general education or core curriculum courses required by your program")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Explore Majors", emojiIcon: "🎓", desc: "If undecided, take introductory courses in different fields to help choose a major")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                let child53 = TreeNode(name: "Academic Advising", emojiIcon: "👩🏻", desc: "Regularly meet with an academic advisor to ensure you’re on track with your degree plan")
                child53.orderKey = 53000
                modelContext.insert(child53)
                child53.progressTree = tree
                child53.parent = child5
                child5.successors.append(child53)
                tree.treeNodes.append(child53)

                ///
                /// Child 6 and successors
                ///
                let child6 = TreeNode(name: "Major and Specialization", emojiIcon: "2️⃣")
                child6.orderKey = 6000
                modelContext.insert(child6)
                child6.progressTree = tree
                child6.parent = rootNode
                rootNode.successors.append(child6)
                tree.treeNodes.append(child6)

                let child61 = TreeNode(name: "Declare a Major", emojiIcon: "🎓", desc: "Choose and declare your major, focusing on specialized courses related to your field of study")
                child61.orderKey = 61000
                modelContext.insert(child61)
                child61.progressTree = tree
                child61.parent = child6
                child6.successors.append(child61)
                tree.treeNodes.append(child61)

                let child62 = TreeNode(name: "Engage in Research and Projects", emojiIcon: "🧑🏽‍🔬", desc: "Participate in research projects, internships, or co-op programs to gain practical experience")
                child62.orderKey = 62000
                modelContext.insert(child62)
                child62.progressTree = tree
                child62.parent = child6
                child6.successors.append(child62)
                tree.treeNodes.append(child62)

                ///
                /// Child 7 and successors
                ///
                let child7 = TreeNode(name: "Advanced Studies and Capstone", emojiIcon: "👨🏼‍🎓")
                child7.orderKey = 7000
                modelContext.insert(child7)
                child7.progressTree = tree
                child7.parent = rootNode
                rootNode.successors.append(child7)
                tree.treeNodes.append(child7)

                let child71 = TreeNode(name: "Complete Major Requirements", emojiIcon: "✅", desc: "Finish all required courses for your major, including advanced and elective courses")
                child71.orderKey = 71000
                modelContext.insert(child71)
                child71.progressTree = tree
                child71.parent = child7
                child7.successors.append(child71)
                tree.treeNodes.append(child71)

                let child72 = TreeNode(name: "Capstone Project or Thesis", emojiIcon: "📝", desc: "Depending on your program, complete a capstone project, thesis, or senior seminar that synthesizes your learning")
                child72.orderKey = 72000
                modelContext.insert(child72)
                child72.progressTree = tree
                child72.parent = child7
                child7.successors.append(child72)
                tree.treeNodes.append(child72)

                let child73 = TreeNode(name: "Prepare for Graduation", emojiIcon: "🥂", desc: "Apply for graduation, ensuring all degree requirements are met")
                child73.orderKey = 73000
                modelContext.insert(child73)
                child73.progressTree = tree
                child73.parent = child7
                child7.successors.append(child73)
                tree.treeNodes.append(child73)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "GENERAL_EXERCISE" {
                let tree = ProgressTree(name: "Exercise", emojiIcon: "🏋🏻‍♀️", color: .green)

                let rootNode = TreeNode(name: "Exercise", emojiIcon: "🏋🏻‍♀️")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Your Current Fitness Level", emojiIcon: "🔍", desc: "Assess your current fitness through simple tests (e.g., a timed run, push-ups, flexibility tests)")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Clear Goals", emojiIcon: "📝", desc: "Define your fitness goals, such as weight loss, muscle gain, improved endurance, or general health. Make them specific, measurable, achievable, relevant, and time-bound")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Plan Your Exercise Routine", emojiIcon: "👨🏻‍🔬")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Choose Your Exercise Types", emojiIcon: "💪", desc: "Select activities that align with your goals—cardio (running, cycling, swimming), strength training (weightlifting, resistance bands), flexibility (yoga, stretching), and balance exercises")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Design a Weekly Schedule", emojiIcon: "🗓️", desc: "Plan a balanced routine that includes various types of exercise")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Determine Workout Duration", emojiIcon: "⏲️", desc: "Start with shorter sessions (20-30 minutes) and gradually increase as your fitness improves")
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Acquire Necessary Equipment and Gear", emojiIcon: "⚙️")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Begin with a Foundation Phase", emojiIcon: "🏃🏽‍♀️‍➡️")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Start Slowly", emojiIcon: "👨🏾‍🎓", desc: "Successfully complete the first 10 sessions")
                child41.repeatTimesToComplete = 10
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Track Improvements", emojiIcon: "📈", desc: "Notice improvements in basic fitness metrics, such as endurance or strength in specific exercises")
                child42.enableProgressiveQuest()
                child42.unit = "reps"
                child42.targetAmount = 20
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Progressive Overload and Intensification", emojiIcon: "📈")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Increase Intensity", emojiIcon: "🥵", desc: "Gradually increase the intensity, duration, or frequency of your workouts to continue making progress")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Strength Training", emojiIcon: "🏋🏽", desc: "Begin adding more challenging exercises or heavier weights to build muscle and strength")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                ///
                /// Child 6 and successors
                ///
                let child6 = TreeNode(name: "Incorporate Specific Training Goals", emojiIcon: "🎯")
                child6.orderKey = 6000
                modelContext.insert(child6)
                child6.progressTree = tree
                child6.parent = rootNode
                rootNode.successors.append(child6)
                tree.treeNodes.append(child6)

                let child61 = TreeNode(name: "Declare a Goal", emojiIcon: "📜", desc: "Start training towards a specific fitness goal")
                child61.orderKey = 61000
                modelContext.insert(child61)
                child61.progressTree = tree
                child61.parent = child6
                child6.successors.append(child61)
                tree.treeNodes.append(child61)

                let child62 = TreeNode(name: "Achieve that Goal", emojiIcon: "✅", desc: "Successfully complete the event or meet the goal you trained for")
                child62.orderKey = 62000
                modelContext.insert(child62)
                child62.progressTree = tree
                child62.parent = child6
                child6.successors.append(child62)
                tree.treeNodes.append(child62)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "COOKING" {
                let tree = ProgressTree(name: "Cooking", emojiIcon: "🍳", color: .yellow)

                let rootNode = TreeNode(name: "Cooking", emojiIcon: "🍳")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Your Current Cooking Skills", emojiIcon: "🔍", desc: "Identify your comfort level in the kitchen—basic, intermediate, or advanced")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Cooking Goals", emojiIcon: "📝", desc: "Define what you want to achieve, such as mastering basic techniques, exploring world cuisines, or preparing healthy meals. Make your goals specific and realistic")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Build a Foundation with Basic Cooking Skills", emojiIcon: "🧱")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Learn Essential Techniques", emojiIcon: "🔪", desc: "Start with the basics, such as chopping, sautéing, boiling, roasting, and baking. Practice these techniques with simple recipes")
                child21.items = [
                    NodeListItem(name: "Chopping", complete: false),
                    NodeListItem(name: "Sautéing", complete: false),
                    NodeListItem(name: "Boiling", complete: false),
                    NodeListItem(name: "Roasting", complete: false),
                    NodeListItem(name: "Baking", complete: false),
                ]
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Understand Kitchen Tools", emojiIcon: "🥘", desc: "Familiarize yourself with essential kitchen tools and how to use them—knives, pots, pans, measuring cups, etc")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Master Basic Recipes", emojiIcon: "🍜", desc: "Start with staple recipes like scrambled eggs, pasta dishes, grilled chicken, and roasted vegetables. This will build your confidence and foundational skills")
                child23.items = [
                    NodeListItem(name: "Scrambled eggs", complete: false),
                    NodeListItem(name: "Pasta dishes", complete: false),
                    NodeListItem(name: "Grilled chicken", complete: false),
                    NodeListItem(name: "Roasted vegetables", complete: false),
                ]
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Expand Your Culinary Knowledge", emojiIcon: "👨🏻‍🍳")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Experiment with Different Cuisines", emojiIcon: "🧪", desc: "Explore different cuisines (Italian, Mexican, Asian, etc.) by trying out traditional recipes and learning about unique ingredients and techniques")
                child31.items = [
                    NodeListItem(name: "Italian", complete: false),
                    NodeListItem(name: "Mexican", complete: false),
                    NodeListItem(name: "Asian", complete: false),
                ]
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Improve Flavoring Skills", emojiIcon: "🧂", desc: "Learn how to properly season food using herbs, spices, and marinades. Understand the balance of flavors—salty, sweet, sour, bitter, and umami")
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                let child33 = TreeNode(name: "Practice Cooking Methods", emojiIcon: "🥘", desc: "Experiment with different cooking methods like grilling, steaming, braising, and frying")
                child33.items = [
                    NodeListItem(name: "Grilling", complete: false),
                    NodeListItem(name: "Steaming", complete: false),
                    NodeListItem(name: "Braising", complete: false),
                    NodeListItem(name: "Frying", complete: false),
                ]
                child33.orderKey = 33000
                modelContext.insert(child33)
                child33.progressTree = tree
                child33.parent = child3
                child3.successors.append(child33)
                tree.treeNodes.append(child33)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Develop Advanced Skills and Techniques", emojiIcon: "🔥")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Refine Your Cooking Techniques", emojiIcon: "🥖", desc: "Move on to more advanced cooking methods, such as sous-vide, fermentation, and advanced baking techniques (e.g., sourdough bread)")
                child41.items = [
                    NodeListItem(name: "Sous-Vide", complete: false),
                    NodeListItem(name: "Fermentation", complete: false),
                    NodeListItem(name: "Advanced Baking", complete: false),
                ]
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Presentation and Plating", emojiIcon: "🍛", desc: "Learn how to plate and present your dishes attractively, paying attention to color, texture, and garnish")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                let child43 = TreeNode(name: "Experiment with Gourmet Recipes", emojiIcon: "🍙", desc: "Challenge yourself with more complex recipes that require precision and attention to detail, such as risottos, soufflés, or multi-course meals")
                child43.items = [
                    NodeListItem(name: "Risotto", complete: false),
                    NodeListItem(name: "Soufflés", complete: false),
                ]
                child43.orderKey = 43000
                modelContext.insert(child43)
                child43.progressTree = tree
                child43.parent = child4
                child4.successors.append(child43)
                tree.treeNodes.append(child43)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Specialization and Personalization", emojiIcon: "🇫🇷")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Specialize in a Cuisine or Technique", emojiIcon: "🥟", desc: "If you have a particular interest, dive deeper into a specific cuisine (e.g., French, Japanese) or cooking technique (e.g., pastry, grilling)")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "MUSIC" {
                let tree = ProgressTree(name: "Music", emojiIcon: "🎼", color: .purple)

                let rootNode = TreeNode(name: "Music", emojiIcon: "🎼")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Current Skills", emojiIcon: "🔍", desc: "Determine your current level in music, whether you're a beginner, intermediate, or advanced")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Clear Goals", emojiIcon: "📝", desc: "Define your musical aspirations—learning an instrument, understanding music theory, composing music, or performing. Make your goals specific and achievable")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Choose Your Instrument or Focus", emojiIcon: "🎸")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Learn the Basics", emojiIcon: "🎻", desc: "Learn the basic components of your instrument (e.g., strings, keys) or fundamental music concepts (e.g., notes, scales)")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Instrumental Basics", emojiIcon: "🎵", desc: "Start with the fundamental techniques of your chosen instrument, such as posture, hand positioning, and basic scales or chords")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Develop a Practice Routine", emojiIcon: "🗓️")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Create a Routine", emojiIcon: "🗓️", desc: "Establish a daily practice routine with at least 20-30 minutes of focused practice")
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Learn a Simple Song", emojiIcon: "🎼", desc: "Learn and perform your first complete piece of music with confidence")
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                let child33 = TreeNode(name: "Ear Training", emojiIcon: "🦻🏼", desc: "Practice recognizing notes, intervals, and chords by ear to improve your musical ear and ability to play by ear")
                child33.orderKey = 33000
                modelContext.insert(child33)
                child33.progressTree = tree
                child33.parent = child3
                child3.successors.append(child33)
                tree.treeNodes.append(child33)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Expand Your Skills", emojiIcon: "🏗️")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Intermediate Techniques", emojiIcon: "🎤", desc: "Learn more advanced techniques for your instrument or voice, such as fingerpicking on guitar, playing with both hands on piano, or singing in harmony")
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Improvisation", emojiIcon: "👐🏻", desc: "Begin exploring improvisation within your practice. This will help you understand musical structure and develop creativity")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                let child43 = TreeNode(name: "Explore Different Genres", emojiIcon: "🆕", desc: "Try playing or singing in different genres (jazz, classical, rock, blues) to broaden your musical horizons")
                child43.orderKey = 43000
                modelContext.insert(child43)
                child43.progressTree = tree
                child43.parent = child4
                child4.successors.append(child43)
                tree.treeNodes.append(child43)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Advanced Practice and Specialization", emojiIcon: "🧠")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Ensemble Playing", emojiIcon: "👨🏻‍🎤", desc: "Join a band, choir, or ensemble to gain experience playing or singing with others. This will improve your timing, listening skills, and adaptability")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Collaborate with Others", emojiIcon: "🌐", desc: "Work on projects with other musicians, whether it’s composing, recording, or performing together")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                let child53 = TreeNode(name: "Performance Opportunities", emojiIcon: "🎭", desc: "Start performing in front of others, whether at open mics, recitals, or small gigs. This will build confidence and stage presence")
                child53.orderKey = 53000
                modelContext.insert(child53)
                child53.progressTree = tree
                child53.parent = child5
                child5.successors.append(child53)
                tree.treeNodes.append(child53)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "LANGUAGE" {
                let tree = ProgressTree(name: "Language", emojiIcon: "🗣️", color: .orange)

                let rootNode = TreeNode(name: "Language", emojiIcon: "🗣️")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Choose a Language", emojiIcon: "🔍", desc: "Select the language you want to learn based on your interests, goals, or professional needs")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Clear Goals", emojiIcon: "📝", desc: "Define your goals, such as basic conversation, fluency, or specialized language use (e.g., business, travel). Make them SMART (Specific, Measurable, Achievable, Relevant, Time-bound)")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Familiarization with the Language", emojiIcon: "👨🏻‍🔬")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Learn the Alphabet and Pronunciation", emojiIcon: "👅", desc: "Start by familiarizing yourself with the language’s alphabet, sounds, and pronunciation rules")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Basic Vocabulary and Phrases", emojiIcon: "💬", desc: "Begin learning essential vocabulary and common phrases that are useful for everyday conversation")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Introduction to Grammar", emojiIcon: "✏️", desc: "Get a basic understanding of the language's grammar structure, including sentence construction, verb conjugation, and gender/noun agreement if applicable")
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Develop a Learning Routine", emojiIcon: "🗓️")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Daily Practice", emojiIcon: "🙇🏼‍♀️", desc: "Establish a consistent daily practice routine, dedicating at least 20-30 minutes each day to language learning")
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Use Language Apps", emojiIcon: "📱", desc: "Incorporate language-learning apps like Duolingo, Babbel, or Memrise for interactive practice")
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Immerse Yourself in the Language", emojiIcon: "🇦🇷")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "Listening Practice", emojiIcon: "🦻🏼", desc: "Listen to podcasts, music, or watch movies in the target language to improve listening comprehension and familiarize yourself with the natural rhythm and intonation")
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Speaking Practice", emojiIcon: "🗣️", desc: "Begin speaking the language as much as possible. Use language exchange apps like Tandem or HelloTalk to converse with native speakers")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                let child43 = TreeNode(name: "Reading Practice", emojiIcon: "📖", desc: "Start reading simple texts like children’s books, short stories, or news articles to build your reading skills and expand your vocabulary")
                child43.orderKey = 43000
                modelContext.insert(child43)
                child43.progressTree = tree
                child43.parent = child4
                child4.successors.append(child43)
                tree.treeNodes.append(child43)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Intermediate Proficiency", emojiIcon: "😎")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Grammar and Syntax", emojiIcon: "📝", desc: "Deepen your understanding of the language's grammar and syntax, tackling more complex sentence structures and verb tenses")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Writing Practice", emojiIcon: "🧑🏻‍💻", desc: "Start writing short paragraphs, essays, or journal entries in the language to improve your writing skills")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                let child53 = TreeNode(name: "Cultural Context", emojiIcon: "🇦🇷", desc: "Learn about the culture associated with the language to understand idiomatic expressions, customs, and the context in which certain phrases are used")
                child53.orderKey = 53000
                modelContext.insert(child53)
                child53.progressTree = tree
                child53.parent = child5
                child5.successors.append(child53)
                tree.treeNodes.append(child53)

                ///
                /// Child 6 and successors
                ///
                let child6 = TreeNode(name: "Advanced Practice and Specialization", emojiIcon: "🧠")
                child6.orderKey = 6000
                modelContext.insert(child6)
                child6.progressTree = tree
                child6.parent = rootNode
                rootNode.successors.append(child6)
                tree.treeNodes.append(child6)

                let child61 = TreeNode(name: "Advanced Vocabulary", emojiIcon: "💬", desc: "Expand your vocabulary to include specialized terms related to your interests, career, or areas of expertise")
                child61.orderKey = 61000
                modelContext.insert(child61)
                child61.progressTree = tree
                child61.parent = child6
                child6.successors.append(child61)
                tree.treeNodes.append(child61)

                let child62 = TreeNode(name: "Advanced Certifications or Degrees", emojiIcon: "🧑🏻‍🎓", desc: "Consider pursuing advanced degrees or certifications as your career progresses")
                child62.orderKey = 62000
                modelContext.insert(child62)
                child62.progressTree = tree
                child62.parent = child6
                child6.successors.append(child62)
                tree.treeNodes.append(child62)

                let child63 = TreeNode(name: "Consistent Conversation Practice", emojiIcon: "🗣️", desc: "Engage in regular conversations with native speakers, focusing on improving fluency and accuracy")
                child63.orderKey = 63000
                modelContext.insert(child63)
                child63.progressTree = tree
                child63.parent = child6
                child6.successors.append(child63)
                tree.treeNodes.append(child63)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }

            if templateId == "FINANCE" {
                let tree = ProgressTree(name: "Personal Finance", emojiIcon: "💰", color: .green)

                let rootNode = TreeNode(name: "Personal Finance", emojiIcon: "💰")
                rootNode.orderKey = 0
                modelContext.insert(rootNode)
                rootNode.progressTree = tree
                tree.treeNodes.append(rootNode)

                ///
                /// Child 1 and successors
                ///
                let child1 = TreeNode(name: "Self-Assessment and Goal Setting", emojiIcon: "🎯")
                child1.orderKey = 1000
                modelContext.insert(child1)
                child1.progressTree = tree
                child1.parent = rootNode
                rootNode.successors.append(child1)
                tree.treeNodes.append(child1)

                let child11 = TreeNode(name: "Evaluate Your Financial Situation", emojiIcon: "🔍", desc: "Assess your current financial status, including income, expenses, debts, savings, and investments")
                child11.orderKey = 11000
                modelContext.insert(child11)
                child11.progressTree = tree
                child11.parent = child1
                child1.successors.append(child11)
                tree.treeNodes.append(child11)

                let child12 = TreeNode(name: "Set Financial Goals", emojiIcon: "📝", desc: "Define short-term (1-2 years), mid-term (3-5 years), and long-term (5+ years) financial goals. Examples include saving for an emergency fund, buying a home, paying off debt, or planning for retirement")
                child12.orderKey = 12000
                modelContext.insert(child12)
                child12.progressTree = tree
                child12.parent = child1
                child1.successors.append(child12)
                tree.treeNodes.append(child12)

                ///
                /// Child 2 and successors
                ///
                let child2 = TreeNode(name: "Create a Budget", emojiIcon: "💵")
                child2.orderKey = 2000
                modelContext.insert(child2)
                child2.progressTree = tree
                child2.parent = rootNode
                rootNode.successors.append(child2)
                tree.treeNodes.append(child2)

                let child21 = TreeNode(name: "Track Income and Expenses", emojiIcon: "🛤️", desc: "Record all sources of income and categorize your expenses (housing, food, transportation, entertainment, etc.)")
                child21.orderKey = 21000
                modelContext.insert(child21)
                child21.progressTree = tree
                child21.parent = child2
                child2.successors.append(child21)
                tree.treeNodes.append(child21)

                let child22 = TreeNode(name: "Develop a Budget", emojiIcon: "📊", desc: "Create a realistic budget that aligns with your goals. Use the 50/30/20 rule as a guideline—50% for needs, 30% for wants, and 20% for savings and debt repayment")
                child22.orderKey = 22000
                modelContext.insert(child22)
                child22.progressTree = tree
                child22.parent = child2
                child2.successors.append(child22)
                tree.treeNodes.append(child22)

                let child23 = TreeNode(name: "Use Budgeting Tools", emojiIcon: "⚒️", desc: "Consider using budgeting apps like YNAB, Mint, or a simple spreadsheet to track your finances")
                child23.orderKey = 23000
                modelContext.insert(child23)
                child23.progressTree = tree
                child23.parent = child2
                child2.successors.append(child23)
                tree.treeNodes.append(child23)
                ///
                /// Child 3 and successors
                ///
                let child3 = TreeNode(name: "Build an Emergency Fund", emojiIcon: "🚨")
                child3.orderKey = 3000
                modelContext.insert(child3)
                child3.progressTree = tree
                child3.parent = rootNode
                rootNode.successors.append(child3)
                tree.treeNodes.append(child3)

                let child31 = TreeNode(name: "Set a Target", emojiIcon: "🎯", desc: "Aim to save at least 3-6 months' worth of living expenses in a high-yield savings account")
                child31.orderKey = 31000
                modelContext.insert(child31)
                child31.progressTree = tree
                child31.parent = child3
                child3.successors.append(child31)
                tree.treeNodes.append(child31)

                let child32 = TreeNode(name: "Automate Savings", emojiIcon: "🤑", desc: "Set up automatic transfers to your savings account to consistently build your emergency fund")
                child32.orderKey = 32000
                modelContext.insert(child32)
                child32.progressTree = tree
                child32.parent = child3
                child3.successors.append(child32)
                tree.treeNodes.append(child32)

                ///
                /// Child 4 and successors
                ///
                let child4 = TreeNode(name: "Manage and Pay Off Debt", emojiIcon: "🔻")
                child4.orderKey = 4000
                modelContext.insert(child4)
                child4.progressTree = tree
                child4.parent = rootNode
                rootNode.successors.append(child4)
                tree.treeNodes.append(child4)

                let child41 = TreeNode(name: "List Your Debts", emojiIcon: "📋", desc: "Make a list of all debts, including credit cards, student loans, car loans, and mortgages, with their interest rates")
                child41.orderKey = 41000
                modelContext.insert(child41)
                child41.progressTree = tree
                child41.parent = child4
                child4.successors.append(child41)
                tree.treeNodes.append(child41)

                let child42 = TreeNode(name: "Debt Repayment Strategy", emojiIcon: "🧠", desc: "Choose a strategy to pay off debt, such as the avalanche method (paying off the highest interest debt first) or the snowball method (paying off the smallest debt first)")
                child42.orderKey = 42000
                modelContext.insert(child42)
                child42.progressTree = tree
                child42.parent = child4
                child4.successors.append(child42)
                tree.treeNodes.append(child42)

                ///
                /// Child 5 and successors
                ///
                let child5 = TreeNode(name: "Start Saving and Investing", emojiIcon: "📈")
                child5.orderKey = 5000
                modelContext.insert(child5)
                child5.progressTree = tree
                child5.parent = rootNode
                rootNode.successors.append(child5)
                tree.treeNodes.append(child5)

                let child51 = TreeNode(name: "Open Savings and Investment Accounts", emojiIcon: "🏦", desc: "Open accounts like a high-yield savings account for short-term goals and an investment account for long-term goals")
                child51.orderKey = 51000
                modelContext.insert(child51)
                child51.progressTree = tree
                child51.parent = child5
                child5.successors.append(child51)
                tree.treeNodes.append(child51)

                let child52 = TreeNode(name: "Contribute to Retirement Accounts", emojiIcon: "🧾", desc: "Maximize contributions to retirement accounts like a 401(k) or IRA, especially if your employer offers matching contributions")
                child52.orderKey = 52000
                modelContext.insert(child52)
                child52.progressTree = tree
                child52.parent = child5
                child5.successors.append(child52)
                tree.treeNodes.append(child52)

                let child53 = TreeNode(name: "Diversify Investments", emojiIcon: "💴", desc: "Begin investing in diversified assets, such as stocks, bonds, and mutual funds. Consider using robo-advisors or consulting with a financial advisor for guidance")
                child53.orderKey = 53000
                modelContext.insert(child53)
                child53.progressTree = tree
                child53.parent = child5
                child5.successors.append(child53)
                tree.treeNodes.append(child53)

                ///
                /// Child 6 and successors
                ///
                let child6 = TreeNode(name: "Increase Financial Literacy", emojiIcon: "🙇🏽‍♂️")
                child6.orderKey = 6000
                modelContext.insert(child6)
                child6.progressTree = tree
                child6.parent = rootNode
                rootNode.successors.append(child6)
                tree.treeNodes.append(child6)

                let child61 = TreeNode(name: "Educate Yourself", emojiIcon: "🧠", desc: "Learn about personal finance topics through books, podcasts, online courses, and financial blogs")
                child61.orderKey = 61000
                modelContext.insert(child61)
                child61.progressTree = tree
                child61.parent = child6
                child6.successors.append(child61)
                tree.treeNodes.append(child61)

                let child62 = TreeNode(name: "Understand Key Concepts", emojiIcon: "🔑", desc: "Focus on understanding budgeting, credit scores, investing, taxes, and retirement planning")
                child62.orderKey = 62000
                modelContext.insert(child62)
                child62.progressTree = tree
                child62.parent = child6
                child6.successors.append(child62)
                tree.treeNodes.append(child62)

                for node in tree.treeNodes { node.updateColor(tree.color) }

                _ = await tree.updateNodeCoordinates(screenDimension: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

                try modelContext.save()
            }
        }
    }

    static let templates: [TemplatePreview] = [
        TemplatePreview(id: "GENERAL_EXERCISE", name: "Exercise", emojiIcon: "🏋🏻‍♀️", color: .green),
        TemplatePreview(id: "COOKING", name: "Cooking", emojiIcon: "🍳", color: .yellow),
        TemplatePreview(id: "FINANCE", name: "Personal Finance", emojiIcon: "💰", color: .green),
        TemplatePreview(id: "LANGUAGE", name: "Language", emojiIcon: "🗣️", color: .orange),
        TemplatePreview(id: "COLLEGE", name: "College", emojiIcon: "👨🏼‍🎓", color: .blue),
        TemplatePreview(id: "MUSIC", name: "Music", emojiIcon: "🎼", color: .purple),
        TemplatePreview(id: "NEW_SKILL", name: "New Skill", emojiIcon: "🆕", color: .green),
    ]
}
