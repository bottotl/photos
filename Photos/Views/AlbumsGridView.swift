/*
精选集视图 - 显示相册网格
*/

import SwiftUI

/// 精选集/相册视图
struct AlbumsGridView: View {
    @Environment(ModelData.self) private var modelData
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: gridColumns,
                spacing: Constants.photoGridSpacing
            ) {
                // 示例相册数据
                ForEach(sampleAlbums) { album in
                    AlbumItemView(album: album)
                }
            }
            .padding()
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle("精选集")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button("新建相册") {
                        // 新建相册操作
                    }
                    Button("排序") {
                        // 排序操作
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }

    // MARK: - 网格列配置

    private var gridColumns: [GridItem] {
        let count: Int
        if horizontalSizeClass == .regular {
            count = 3 // iPad
        } else {
            count = 2 // iPhone
        }
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }

    // MARK: - 示例数据

    private var sampleAlbums: [Album] {
        [
            Album(name: "最近项目", count: 42, gradient: LinearGradient(
                colors: [Color(hex: "FF6B6B"), Color(hex: "4ECDC4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )),
            Album(name: "收藏", count: 28, gradient: LinearGradient(
                colors: [Color(hex: "A8E6CF"), Color(hex: "DCEDC1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )),
            Album(name: "人物", count: 156, gradient: LinearGradient(
                colors: [Color(hex: "FFD93D"), Color(hex: "6BCF7F")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )),
            Album(name: "地点", count: 89, gradient: LinearGradient(
                colors: [Color(hex: "95E1D3"), Color(hex: "38ADA9")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        ]
    }
}

// MARK: - Album Model

struct Album: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let gradient: LinearGradient
}

// MARK: - 相册项视图

struct AlbumItemView: View {
    let album: Album

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 相册封面
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(album.gradient)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "photo.stack")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                                .padding()
                        }
                    }
                )

            // 相册信息
            VStack(alignment: .leading, spacing: 4) {
                Text(album.name)
                    .font(.headline)

                Text("\(album.count) 项")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - 预览

#Preview {
    @Previewable @State var modelData = ModelData()

    NavigationStack {
        AlbumsGridView()
            .environment(modelData)
    }
}
