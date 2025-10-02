/*
照片网格视图 - 参考 Landmarks 的设计模式
使用标准 NavigationStack + toolbar 架构
*/

import SwiftUI

/// 照片网格主视图
struct PhotosGridView: View {
    @Environment(ModelData.self) private var modelData
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let onScrollToBottomAction: (@escaping () -> Void) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: gridColumns,
                    spacing: Constants.photoGridSpacing
                ) {
                    ForEach(modelData.sortedMediaItems) { item in
                        photoItemButton(for: item)
                            .id(item.id)
                    }
                }
            }
            .defaultScrollAnchor(.bottom)
            .ignoresSafeArea(edges: .top)
            .onScrollGeometryChange(for: Bool.self) { geometry in
                let contentHeight = geometry.contentSize.height
                let visibleHeight = geometry.containerSize.height
                let offsetY = geometry.contentOffset.y

                // 计算距离底部的距离
                let distance = contentHeight - (offsetY + visibleHeight)

                // 距离底部 < 50 认为在底部
                return distance < 50
            } action: { _, isAtBottom in
                if modelData.isAtBottom != isAtBottom {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        modelData.isAtBottom = isAtBottom
                    }
                }
            }
            .onAppear {
                // 提供滚动到底部的回调
                onScrollToBottomAction {
                    guard let lastItem = modelData.sortedMediaItems.last else { return }
                    withAnimation(.spring(response: 0.4)) {
                        proxy.scrollTo(lastItem.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - 照片项按钮

    @ViewBuilder
    private func photoItemButton(for item: MediaItem) -> some View {
        if modelData.isSelectMode {
            // 选择模式：点击切换选中状态
            Button {
                toggleSelection(for: item)
            } label: {
                PhotoItemView(mediaItem: item)
                    .overlay(alignment: .topTrailing) {
                        selectionIndicator(for: item)
                    }
            }
            .buttonStyle(.plain)
        } else {
            // 普通模式：导航到详情页
            NavigationLink(value: item) {
                PhotoItemView(mediaItem: item)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 选择指示器

    @ViewBuilder
    private func selectionIndicator(for item: MediaItem) -> some View {
        let isSelected = modelData.selectedItems.contains(item.id)

        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 24))
            .foregroundStyle(isSelected ? .blue : .white)
            .shadow(color: .black.opacity(0.3), radius: 2)
            .padding(8)
    }

    // MARK: - 辅助方法

    private func toggleSelection(for item: MediaItem) {
        withAnimation {
            if modelData.selectedItems.contains(item.id) {
                modelData.selectedItems.remove(item.id)
            } else {
                modelData.selectedItems.insert(item.id)
            }
        }
    }

    // MARK: - 网格列配置

    private var gridColumns: [GridItem] {
        let count: Int
        if horizontalSizeClass == .regular {
            count = 6 // iPad
        } else {
            // iPhone - 使用窗口尺寸而非 UIScreen.main（iOS 26 推荐）
            let width = modelData.windowSize.width
            count = width > 600 ? 4 : 3
        }
        return Array(repeating: GridItem(.flexible(), spacing: Constants.photoGridSpacing), count: count)
    }
}

// MARK: - 照片详情视图

struct PhotoDetailView: View {
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // 背景渐变
            mediaItem.gradient
                .ignoresSafeArea()

            // 内容
            VStack {
                if let duration = mediaItem.videoDuration {
                    Text("视频时长: \(duration)")
                        .font(.title)
                        .foregroundColor(.white)
                } else {
                    Text("照片详情")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 左侧返回按钮
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
            }

            // 右侧操作按钮
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    Button(action: {
                        // 分享操作
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }

                    Button(action: {
                        // 更多操作
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - 预览

#Preview {
    @Previewable @State var modelData = ModelData()

    PhotosGridView(onScrollToBottomAction: { _ in })
        .environment(modelData)
        .onGeometryChange(for: CGSize.self) { geometry in
            geometry.size
        } action: {
            modelData.windowSize = $0
        }
}
