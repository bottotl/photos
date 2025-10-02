/*
照片主视图 - 包含底部 Tab Bar 切换不同视图
图库(网格) 和 精选集(相册)
*/

import SwiftUI

/// 照片主视图 - 固定的导航 TabView
struct PhotosMainView: View {
    @Environment(ModelData.self) private var modelData
    @State private var selectedTab: PhotosTab = .grid
    @State private var scrollToBottomAction: (() -> Void)?

    /// 导航 Tab 选项
    enum PhotosTab: Hashable {
        case grid      // 图库(照片网格)
        case albums    // 精选集(相册)
    }

    var body: some View {
        @Bindable var modelData = modelData

        TabView(selection: $selectedTab) {
            PhotosGridView(onScrollToBottomAction: { action in
                scrollToBottomAction = action
            })
            .tag(PhotosTab.grid)
            .toolbar(.hidden, for: .tabBar)

            AlbumsGridView()
                .tag(PhotosTab.albums)
                .toolbar(.hidden, for: .tabBar)
        }
        .navigationTitle(navigationTitle)
        .navigationSubtitle(navigationSubtitle)
        .toolbar {
            if selectedTab == .grid {
                gridToolbarContent
            }

            bottomToolbarContent
        }
        .overlay(alignment: .top) {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.3),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)
        }
    }

    // MARK: - 导航标题

    private var navigationTitle: String {
        switch selectedTab {
        case .grid: "图库"
        case .albums: "精选集"
        }
    }

    private var navigationSubtitle: String {
        switch selectedTab {
        case .grid:
            return modelData.titleSubtitle
        case .albums:
            return "" // 精选集暂不显示副标题
        }
    }

    // MARK: - Toolbar 内容

    @ToolbarContentBuilder
    private var gridToolbarContent: some ToolbarContent {
        // 弹性间距 - 把按钮推到右边
        ToolbarSpacer(.flexible)

        // 排序菜单按钮
        ToolbarItem {
            Menu {
                ForEach(SortOption.allCases) { option in
                    Button {
                        modelData.sortOption = option
                    } label: {
                        Label {
                            Text(option.rawValue)
                        } icon: {
                            Image(systemName: option.iconName)
                        }
                        if modelData.sortOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                Label("排序", systemImage: "line.3.horizontal")
            }
            .menuIndicator(.hidden)
        }

        // 固定间距 - 按钮之间的间隔
        ToolbarSpacer(.fixed)

        // 选择按钮
        ToolbarItem {
            Button(modelData.isSelectMode ? "取消" : "选择") {
                withAnimation {
                    modelData.isSelectMode.toggle()
                    if !modelData.isSelectMode {
                        modelData.selectedItems.removeAll()
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var bottomToolbarContent: some ToolbarContent {
        // 左侧：返回按钮（仅在年月日模式显示）
        if shouldShowTimelineFilter {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        scrollToBottomAction?()
                    }
                } label: {
                    Image(systemName: "photo.on.rectangle")
                }
                .accessibilityLabel("返回图库底部")
            }

            ToolbarSpacer(.fixed)
        }

        // 中间：Segmented Control
        ToolbarItem(placement: .bottomBar) {
            if shouldShowTimelineFilter {
                // 年月日筛选器
                Picker("时间筛选", selection: Binding(
                    get: { modelData.timelineFilter },
                    set: { modelData.timelineFilter = $0 }
                )) {
                    Text("年").tag(TimelineFilter.year)
                    Text("月").tag(TimelineFilter.month)
                    Text("全部").tag(TimelineFilter.all)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            } else {
                // Tab 切换器
                Picker("切换视图", selection: $selectedTab) {
                    Text("图库").tag(PhotosTab.grid)
                    Text("精选集").tag(PhotosTab.albums)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }

        ToolbarSpacer(.flexible)

        // 右侧：搜索按钮
        ToolbarItem(placement: .bottomBar) {
            Button {
                // 搜索操作
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .accessibilityLabel("搜索")
        }
    }

    // MARK: - 辅助属性

    /// 是否显示时间筛选器（而非 Tab 切换器）
    private var shouldShowTimelineFilter: Bool {
        selectedTab == .grid && !modelData.isAtBottom
    }
}

#Preview {
    @Previewable @State var modelData = ModelData()

    NavigationStack {
        PhotosMainView()
            .environment(modelData)
            .onGeometryChange(for: CGSize.self) { geometry in
                geometry.size
            } action: {
                modelData.windowSize = $0
            }
    }
}
