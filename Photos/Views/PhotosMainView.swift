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
