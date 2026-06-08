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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            PhotosBottomBar(
                mode: bottomBarMode,
                selectedTab: $selectedTab,
                timelineFilter: $modelData.timelineFilter,
                scrollToBottom: {
                    withAnimation(.spring(response: 0.3)) {
                        scrollToBottomAction?()
                    }
                },
                search: {
                    // 搜索操作
                }
            )
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

    // MARK: - 辅助属性

    /// 底部栏形态：图库底部是图库/精选集，向上滚动后切到年/月/全部。
    private var bottomBarMode: PhotosBottomBarMode {
        selectedTab == .grid && !modelData.isAtBottom ? .timeline : .library
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
