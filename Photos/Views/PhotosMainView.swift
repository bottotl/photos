/*
照片主视图 - 包含底部 Tab Bar 切换不同视图
图库(网格) 和 精选集(相册)
*/

import SwiftUI

/// 照片主视图 - 使用 TabView 切换图库和精选集
struct PhotosMainView: View {
    @Environment(ModelData.self) private var modelData
    @State private var selectedTab: PhotosTab = .grid

    /// Tab 选项
    enum PhotosTab {
        case grid      // 图库(照片网格)
        case albums    // 精选集(相册)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // 图库标签 - 照片网格视图
            PhotosGridView()
                .tabItem {
                    Label("图库", systemImage: "photo.on.rectangle")
                }
                .tag(PhotosTab.grid)

            // 精选集标签 - 相册视图
            AlbumsGridView()
                .tabItem {
                    Label("精选集", systemImage: "square.stack")
                }
                .tag(PhotosTab.albums)
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            if selectedTab == .grid {
                gridToolbarContent
            }
        }
    }

    // MARK: - 导航标题

    private var navigationTitle: String {
        switch selectedTab {
        case .grid: "图库"
        case .albums: "精选集"
        }
    }

    // MARK: - 图库 Toolbar 内容

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
