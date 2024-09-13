//
//  ContentView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

import RevenueCat
import SwiftData
import SwiftUI

class AppDateFormatter {
    static let shared = AppDateFormatter()

    var formatter: DateFormatter

    private init() {
        let nativeFormatter = DateFormatter()
        nativeFormatter.locale = .current
        nativeFormatter.dateStyle = .full
        nativeFormatter.timeStyle = .full

        formatter = nativeFormatter
    }
}

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var surveySheetHandler: SurveySheetHandler

    @State private var viewModel: ViewModel

    var showPaywall: () -> Void

    var body: some View {
        Group {
            if settings.onboardingFinished {
                NavigationStack {
                    ZStack {
                        VStack(alignment: .center) {
//                            HStack {
//                                HStack {
//                                    Image(systemName: "flame")
//                                        .font(.system(size: 18))
//                                        .foregroundStyle(AppColors.textGray)
//
//                                    Text("\(settings.streakDays)")
//                                        .fontWeight(.medium)
//                                        .font(.system(size: 18))
//                                        .foregroundStyle(.white)
//                                        .contentTransition(.numericText())
//                                }
//                                .frame(height: 33)
//                                .padding(.horizontal)
//                                .background(AppColors.darkGray)
//                                .cornerRadius(15)
//
//                                Spacer()
//
//                                Button("", systemImage: "gear") {}
//                                    .font(.system(size: 20))
//                            }
//                            .padding(.horizontal)

                            HStack {
                                Text("Progress Trees")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 34).bold())

                                Spacer()

                                Button(action: { viewModel.showingAddNewTreePopUp = true }) {
                                    Text("Add")
                                        .font(.system(size: 18))
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .foregroundColor(.accentColor)
                                        .background(.blue.opacity(0.3))
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)

                            ScrollView {
                                LazyVStack {
                                    ///
                                    /// JOIN COMMUNITY BUTTON
                                    /// Visible only after the user uses the app for 1 day
                                    /// After the user presses the close button it should show up again
                                    /// Tapping it takes you to the discord server
                                    ///
                                    if settings.daysSinceFirstOpen >= 1 && !settings.doNotShowDiscordPopUpAgain {
                                        Link(destination: URL(string: "https://discord.gg/nMjHEdhg8m")!) {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Text("We’d love to hear your thoughts")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.white)

                                                    Text("Tap here to join our Discord")
                                                        .font(.system(size: 14))
                                                        .foregroundStyle(AppColors.textGray)
                                                }

                                                Spacer()

                                                Image(systemName: "xmark")
                                                    .font(.system(size: 14).bold())
                                                    .foregroundColor(AppColors.textGray)
                                                    .frame(width: 24, height: 24)
                                                    .background(AppColors.darkGray)
                                                    .cornerRadius(20)
                                                    .onTapGesture { withAnimation { settings.doNotShowDiscordPopUpAgain = true } }
                                            }
                                            .padding()
                                            .background(AppColors.semiDarkGray)
                                            .cornerRadius(10)
                                            .padding(.bottom)
                                        }
                                    }

//                                ///
//                                /// OPEN COLLECTION BUTTON
//                                /// Navigates only after the user earns their first collectible (🚨 NOT IMPLEMENTED)
//                                /// Lock icon goes away after the user earns their first collectible (🚨 NOT IMPLEMENTED)
//                                ///
//                                if false {
//                                    NavigationLink(destination: Text("Hello, World!")) {}
//                                        .opacity(0)
//                                        .background(
//                                            HStack {
//                                                Image(systemName: "lock.fill")
//                                                    .foregroundColor(AppColors.textGray)
//
//                                                Text("Collection")
//                                                    .foregroundColor(.white)
//                                                Spacer()
//                                                Image(systemName: "chevron.right")
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 7)
//                                                    .foregroundColor(AppColors.textGray)
//                                            }
//                                        )
//                                        .listRowBackground(AppColors.semiDarkGray)
//                                } else {
//                                    Button(action: { viewModel.showingCollectionNotAvailablePopUp = true }) {
//                                        HStack {
//                                            Image(systemName: "lock.fill")
//                                                .foregroundColor(AppColors.textGray)
//
//                                            Text("Collection")
//                                                .foregroundColor(.white)
//                                            Spacer()
//                                            Image(systemName: "chevron.right")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 7)
//                                                .foregroundColor(AppColors.textGray)
//                                        }
//                                    }
//                                    .listRowBackground(AppColors.semiDarkGray)
//                                }

                                    ///
                                    /// List of all Progress Trees
                                    ///
                                    ForEach(viewModel.progressTrees) { tree in
                                        ///
                                        /// Progress Tree Card With Navigation
                                        ///
                                        NavigationLink(value: tree) { ProgressTreeCardView(tree: tree) }
                                            .foregroundStyle(.white)
                                            .contextMenu {
                                                Button("Edit", systemImage: "pencil") {
                                                    viewModel.editingProgressTree = tree
                                                }
                                            }
                                            .padding(.bottom)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .navigationDestination(for: ProgressTree.self) { tree in
                                ProgressTreeView(modelContext: viewModel.modelContext, progressTreeId: tree.persistentModelID)
                            }
                            .scrollContentBackground(.hidden)
                            .listStyle(InsetGroupedListStyle())
                            .scrollBounceBehavior(.basedOnSize)
                            .scrollIndicators(.hidden)
                        }

                        .padding(.vertical)
                        .background(.black)
                        .allowsHitTesting(!viewModel.showingCollectionNotAvailablePopUp)

                        if viewModel.showingCollectionNotAvailablePopUp {
                            DialoguePopUpView(
                                title: "Get your first Fiber to unlock your Collection",
                                messages: [["Complete a milestone in any Progress Tree to get your first Fiber"]],
                                buttonTitle: viewModel.progressTrees.isEmpty ? "Create Your First Progress Tree" : "Continue",
                                action: {
                                    viewModel.showingCollectionNotAvailablePopUp = false

                                    if viewModel.progressTrees.isEmpty { viewModel.showingAddNewTreePopUp = true }
                                }
                            )
                        }
                    }
                    .sheet(isPresented: $viewModel.showingAddNewTreePopUp) {
                        AddNewProgressTreeView(addProgressTree: viewModel.addProgressTree, addTemplate: viewModel.addTemplateTree)
                    }
                    .sheet(item: $viewModel.editingProgressTree, content: { tree in
                        EditProgressTreeView(
                            tree: tree,
                            deleteTree: viewModel.deleteTree,
                            saveProgressTreeEdit: viewModel.saveProgressTreeEdit
                        )
                    })
                    /// Each time the app becomes active this function runs
                    .onChange(of: scenePhase, initial: true) { _, newPhase in
                        if newPhase == .active {
                            Task {
                                await surveySheetHandler.runOnAppActive(countCompleteOrProgressedNodes: viewModel.countCompleteOrProgressedNodes)
                            }
                        }
                    }
                }

            } else {
                OnboardingView(completeOnboarding: {
                    settings.onboardingFinished = true
                    showPaywall()
                    viewModel.fetchData()
                })
            }
        }
    }

    init(modelContext: ModelContext, showPaywall: @escaping () -> Void) {
        _viewModel = State(initialValue: ViewModel(modelContext: modelContext))
        self.showPaywall = showPaywall
    }
}

#Preview {
    let settings = Settings()
    settings.onboardingFinished = true

    return ContentView(modelContext: SwiftDataController.previewContainer.mainContext, showPaywall: {})
        .environmentObject(settings)
        .modelContainer(SwiftDataController.previewContainer)
}
