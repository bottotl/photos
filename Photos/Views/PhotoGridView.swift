import SwiftUI

// MARK: - 照片网格视图
struct PhotoGridView: View {
    let mediaItems: [MediaItem]
    let onItemTap: (MediaItem) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(ModelData.self) private var modelData

    // 根据屏幕尺寸调整列数
    private var columns: [GridItem] {
        let count: Int
        if horizontalSizeClass == .regular {
            count = 6 // iPad 或大屏
        } else {
            // iPhone - 使用窗口尺寸而非 UIScreen.main（iOS 26 推荐）
            let width = modelData.windowSize.width
            count = width > 600 ? 4 : 3
        }
        return Array(repeating: GridItem(.flexible(), spacing: 2), count: count)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(mediaItems) { item in
                    PhotoItemView(mediaItem: item)
                        .onTapGesture {
                            onItemTap(item)
                        }
                }
            }
            .padding(.top, 56) // 导航栏高度
            .padding(.bottom, 64) // Tab Bar 高度
        }
    }
}
