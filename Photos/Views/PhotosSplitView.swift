/*
参考 Landmarks 项目的 LandmarksSplitView.swift
Photos 应用的主导航容器
*/

import SwiftUI

/// Photos 应用的主导航容器 - 使用 NavigationSplitView 架构
struct PhotosSplitView: View {
    @Environment(ModelData.self) var modelData
    @State private var preferredColumn: NavigationSplitViewColumn = .detail

    var body: some View {
        @Bindable var modelData = modelData

        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List {
                Section {
                    ForEach(NavigationOptions.mainPages) { page in
                        NavigationLink(value: page) {
                            Label(page.name, systemImage: page.symbolName)
                        }
                    }
                }
            }
            .navigationDestination(for: NavigationOptions.self) { page in
                NavigationStack(path: $modelData.path) {
                    page.viewForPage()
                }
                .navigationDestination(for: MediaItem.self) { item in
                    PhotoDetailView(mediaItem: item)
                }
            }
            .frame(minWidth: 150)
        } detail: {
            NavigationStack(path: $modelData.path) {
                NavigationOptions.photos.viewForPage()
            }
            .navigationDestination(for: MediaItem.self) { item in
                PhotoDetailView(mediaItem: item)
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .searchable(text: $modelData.searchString, prompt: "搜索照片")
    }
}

#Preview {
    @Previewable @State var modelData = ModelData()

    PhotosSplitView()
        .environment(modelData)
        .onGeometryChange(for: CGSize.self) { geometry in
            geometry.size
        } action: {
            modelData.windowSize = $0
        }
}
