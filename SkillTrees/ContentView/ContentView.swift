//
//  ContentView.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 02/08/2024.
//

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
    @State private var viewModel: ViewModel

    @StateObject var settings = Settings()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        HStack {
                            Image(systemName: "flame")
                                .font(.system(size: 18))
                                .foregroundStyle(AppColors.textGray)

                            Text("\(settings.streakDays)")
                                .fontWeight(.medium)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())
                        }
                        .frame(height: 33)
                        .padding(.horizontal)
                        .background(AppColors.darkGray)
                        .cornerRadius(15)

                        Spacer()

                        Button("", systemImage: "gear") {}
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal)

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

                    List {
                        ///
                        /// JOIN COMMUNITY BUTTON
                        /// Visible only after the user uses the app for 3 days
                        /// After the user presses the close button it should show up again
                        /// Tapping it takes you to the discord server (🚨 NOT IMPLEMENTED)
                        ///
                        if settings.daysSinceFirstOpen >= 3 && !settings.doNotShowDiscordPopUpAgain {
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
                            .listRowBackground(AppColors.semiDarkGray)
                        }

                        ///
                        /// OPEN COLLECTION BUTTON
                        /// Navigates only after the user earns their first collectible (🚨 NOT IMPLEMENTED)
                        /// Lock icon goes away after the user earns their first collectible (🚨 NOT IMPLEMENTED)
                        ///
                        if false {
                            NavigationLink(destination: Text("Hello, World!")) {}
                                .opacity(0)
                                .background(
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(AppColors.textGray)

                                        Text("Collection")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 7)
                                            .foregroundColor(AppColors.textGray)
                                    }
                                )
                                .listRowBackground(AppColors.semiDarkGray)
                        } else {
                            Button(action: { viewModel.showingCollectionNotAvailablePopUp = true }) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(AppColors.textGray)

                                    Text("Collection")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 7)
                                        .foregroundColor(AppColors.textGray)
                                }
                            }
                            .listRowBackground(AppColors.semiDarkGray)
                        }

                        ///
                        /// List of all Progress Trees
                        ///
                        ForEach(viewModel.progressTrees) { tree in
                            ///
                            /// Progress Tree Card With Navigation
                            ///
                            NavigationLink(value: tree) {}
                                .opacity(0)
                                .background(ProgressTreeCardView(tree: tree))
                                .listRowInsets(EdgeInsets())
                                .frame(height: 180)
                                .listRowBackground(AppColors.semiDarkGray)
                                .swipeActions {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        withAnimation { viewModel.deleteTree(tree: tree) }
                                    }
                                }
                                .contextMenu {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        withAnimation { viewModel.deleteTree(tree: tree) }
                                    }
                                }
                        }
                    }
                    .navigationDestination(for: ProgressTree.self) { tree in ProgressTreeView(modelContext: viewModel.modelContext, progressTreeId: tree.persistentModelID) }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .listRowSpacing(18)
                    .environment(\.defaultMinListRowHeight, 10)
                    .scrollBounceBehavior(.basedOnSize)
                    .offset(y: -35)
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
                AddNewProgressTreeView(addProgressTree: viewModel.addProgressTree)
            }
        }
        .environmentObject(settings)
        /// Each time the app becomes active this function runs
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            settings.updateStreak()
        }
    }

    init(modelContext: ModelContext) {
        _viewModel = State(initialValue: ViewModel(modelContext: modelContext))
    }
}

#Preview {
    ContentView(modelContext: SwiftDataController.previewContainer.mainContext)
        .modelContainer(SwiftDataController.previewContainer)
}
