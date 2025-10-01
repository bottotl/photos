/*
照片网格视图 - 参考 Landmarks 的设计模式
使用标准 NavigationStack + toolbar 架构
*/

import SwiftUI

/// 照片网格主视图
struct PhotosGridView: View {
    @Environment(ModelData.self) private var modelData
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: gridColumns,
                spacing: Constants.photoGridSpacing
            ) {
                ForEach(modelData.mediaItems) { item in
                    NavigationLink(value: item) {
                        PhotoItemView(mediaItem: item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .defaultScrollAnchor(.bottom)
        .ignoresSafeArea(edges: .top)
        .navigationTitle("图库")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button("设置") {
                        // 设置操作
                    }
                    Button("关于") {
                        // 关于操作
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }

            ToolbarItem(placement: .automatic) {
                Button("选择") {
                    // 选择操作
                }
            }
        }
    }

    // MARK: - 网格列配置

    private var gridColumns: [GridItem] {
        let count: Int
        if horizontalSizeClass == .regular {
            count = 6 // iPad
        } else {
            let width = UIScreen.main.bounds.width
            count = width > 600 ? 4 : 3 // iPhone
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

    PhotosGridView()
        .environment(modelData)
        .onGeometryChange(for: CGSize.self) { geometry in
            geometry.size
        } action: {
            modelData.windowSize = $0
        }
}
