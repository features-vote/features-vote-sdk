import SwiftUI

/// Roadmap view with Kanban board layout
public struct RoadmapView: View {
    @StateObject private var viewModel: RoadmapViewModel
    @State private var showCreateSheet = false
    @State private var selectedFeature: Feature?

    private let theme: Theme
    private let config: Configuration
    private let localization: Localization

    public init(
        viewModel: RoadmapViewModel,
        theme: Theme = .default,
        config: Configuration = .default,
        localization: Localization = .default
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.theme = theme
        self.config = config
        self.localization = localization
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle(viewModel.project?.customization.roadmapLabel ?? "Roadmap")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showCreateSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }

                    ToolbarItem(placement: .secondaryAction) {
                        Menu {
                            Picker("Sort", selection: $viewModel.sortOrder) {
                                ForEach(RoadmapSortOrder.allCases, id: \.self) { order in
                                    Text(order.rawValue).tag(order)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
                // Confirmation dialog for voting
                .alert("Confirm Vote", isPresented: $viewModel.showVoteConfirmation) {
                    Button("Vote") {
                        Task { await viewModel.confirmPendingVote() }
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.cancelPendingVote()
                    }
                } message: {
                    Text("Are you sure you want to cast your vote for this feature?")
                }
                // Permission error (anonymous user blocked)
                .alert(
                    "Sign In Required",
                    isPresented: $viewModel.showPermissionAlert,
                    actions: { Button("OK", role: .cancel) { viewModel.clearPermissionError() } },
                    message: { Text(viewModel.permissionError ?? "") }
                )
                .sheet(isPresented: $showCreateSheet) {
                    if let project = viewModel.project {
                        CreateFeatureSheet(
                            slug: project.slug,
                            availableTags: project.customization.tags ?? [],
                            projectCustomization: project.customization,
                            theme: theme,
                            config: config,
                            localization: localization,
                            userService: viewModel.userService
                        )
                    }
                }
                .sheet(item: $selectedFeature) { feature in
                    NavigationStack {
                        InternalFeatureDetailView(
                            feature: feature,
                            slug: viewModel.slug,
                            theme: theme,
                            config: config,
                            localization: localization,
                            projectLogoUrl: viewModel.project?.logoUrl,
                            projectCustomization: viewModel.project?.customization,
                            userService: viewModel.userService,
                            onFeatureUpdated: { updatedFeature in
                                viewModel.updateFeature(updatedFeature)
                            }
                        )
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Done") {
                                    selectedFeature = nil
                                }
                            }
                        }
                    }
                }
        }
        .task {
            await viewModel.loadProject()
            await viewModel.loadFeatures()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.features.isEmpty {
            LoadingView()
        } else if let error = viewModel.error, viewModel.features.isEmpty {
            ErrorView(error: error) {
                Task {
                    await viewModel.loadFeatures()
                }
            }
        } else {
            kanbanBoard
        }
    }

    private var kanbanBoard: some View {
        GeometryReader { geometry in
            #if os(iOS)
            // Mobile: Scrollable horizontal columns
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(viewModel.statusColumns, id: \.self) { status in
                        columnView(for: status)
                            .frame(width: geometry.size.width * 0.85)
                    }
                }
                .padding()
            }
            #elseif os(macOS)
            // Desktop: 5-column grid
            ScrollView {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(viewModel.statusColumns, id: \.self) { status in
                        columnView(for: status)
                            .frame(minWidth: 250, maxWidth: .infinity)
                    }
                }
                .padding()
            }
            #endif
        }
    }

    private func columnView(for status: FeatureStatus) -> some View {
        let features = viewModel.featuresByStatus[status] ?? []

        return RoadmapColumnView(
            status: status,
            features: features,
            theme: theme,
            config: config,
            availableTags: viewModel.project?.customization.tags ?? [],
            onVote: { feature in
                viewModel.requestVote(for: feature)
            },
            onFeatureTap: { feature in
                selectedFeature = feature
            }
        )
    }
}

#if DEBUG
struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(
            viewModel: RoadmapViewModel(
                slug: "demo",
                featureService: FeatureService(),
                voteService: VoteService(),
                userService: UserService()
            )
        )
    }
}
#endif
