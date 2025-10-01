/*
参考 Landmarks 项目的 ModelData.swift
Photos 应用的数据管理类
*/

import Foundation
import SwiftUI

/// 排序选项
enum SortOption: String, CaseIterable, Identifiable {
    case dateNewest = "最新优先"
    case dateOldest = "最早优先"
    case typePhoto = "仅照片"
    case typeVideo = "仅视频"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .dateNewest: return "arrow.down"
        case .dateOldest: return "arrow.up"
        case .typePhoto: return "photo"
        case .typeVideo: return "video"
        }
    }
}

/// Photos 应用的数据管理类
@Observable @MainActor
class ModelData {
    var mediaItems: [MediaItem] = []
    var selectedMediaItem: MediaItem? = nil

    var searchString: String = ""
    var path: NavigationPath = NavigationPath()

    var windowSize: CGSize = .zero

    // 排序和选择状态
    var sortOption: SortOption = .dateNewest
    var isSelectMode: Bool = false
    var selectedItems: Set<UUID> = []

    init() {
        loadMediaItems()
    }

    // MARK: - 排序后的媒体项

    var sortedMediaItems: [MediaItem] {
        switch sortOption {
        case .dateNewest:
            return mediaItems.reversed()
        case .dateOldest:
            return mediaItems
        case .typePhoto:
            return mediaItems.filter { !$0.isVideo }
        case .typeVideo:
            return mediaItems.filter { $0.isVideo }
        }
    }

    // MARK: - 副标题

    /// 根据当前排序选项生成副标题
    var titleSubtitle: String {
        switch sortOption {
        case .dateNewest, .dateOldest:
            // 显示当前日期
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日"
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter.string(from: Date())

        case .typePhoto:
            // 显示照片数量
            let count = sortedMediaItems.count
            return "\(count)个照片"

        case .typeVideo:
            // 显示视频数量
            let count = sortedMediaItems.count
            return "\(count)个视频"
        }
    }

    // MARK: - 加载媒体数据

    func loadMediaItems() {
        mediaItems = [
            // 照片1
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片2
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 视频1
            MediaItem(type: .video(duration: 15), gradient: LinearGradient(
                colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片4
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "43e97b"), Color(hex: "38f9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片5
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fa709a"), Color(hex: "fee140")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片6
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "30cfd0"), Color(hex: "330867")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 视频2
            MediaItem(type: .video(duration: 30), gradient: LinearGradient(
                colors: [Color(hex: "a8edea"), Color(hex: "fed6e3")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片8
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "ff9a9e"), Color(hex: "fecfef")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片9
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fbc2eb"), Color(hex: "a6c1ee")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 视频3
            MediaItem(type: .video(duration: 83), gradient: LinearGradient(
                colors: [Color(hex: "fdcbf1"), Color(hex: "e6dee9")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片11
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "a1c4fd"), Color(hex: "c2e9fb")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片12
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "d299c2"), Color(hex: "fef9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片13
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "ffecd2"), Color(hex: "fcb69f")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 视频4
            MediaItem(type: .video(duration: 45), gradient: LinearGradient(
                colors: [Color(hex: "ff6e7f"), Color(hex: "bfe9ff")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 照片15-27
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "e0c3fc"), Color(hex: "8ec5fc")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 130), gradient: LinearGradient(
                colors: [Color(hex: "43e97b"), Color(hex: "38f9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fa709a"), Color(hex: "fee140")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "30cfd0"), Color(hex: "330867")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "a8edea"), Color(hex: "fed6e3")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 52), gradient: LinearGradient(
                colors: [Color(hex: "ff9a9e"), Color(hex: "fecfef")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fbc2eb"), Color(hex: "a6c1ee")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fdcbf1"), Color(hex: "e6dee9")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "a1c4fd"), Color(hex: "c2e9fb")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "d299c2"), Color(hex: "fef9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "ffecd2"), Color(hex: "fcb69f")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),

            // 继续添加更多媒体项 (28-60)
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 18), gradient: LinearGradient(
                colors: [Color(hex: "ff6a00"), Color(hex: "ee0979")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "00c6ff"), Color(hex: "0072ff")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "f857a6"), Color(hex: "ff5858")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "2af598"), Color(hex: "009efd")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 65), gradient: LinearGradient(
                colors: [Color(hex: "fa709a"), Color(hex: "fee140")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "9890e3"), Color(hex: "b1f4cf")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "eea2a2"), Color(hex: "bbc1bf")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "56ccf2"), Color(hex: "2f80ed")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 42), gradient: LinearGradient(
                colors: [Color(hex: "f5af19"), Color(hex: "f12711")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "c471f5"), Color(hex: "fa71cd")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "3c3b3f"), Color(hex: "605c3c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "f2709c"), Color(hex: "ff9472")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 95), gradient: LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fdfbfb"), Color(hex: "ebedee")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "43e97b"), Color(hex: "38f9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 28), gradient: LinearGradient(
                colors: [Color(hex: "fa709a"), Color(hex: "fee140")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "30cfd0"), Color(hex: "330867")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "a8edea"), Color(hex: "fed6e3")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "ff9a9e"), Color(hex: "fecfef")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 73), gradient: LinearGradient(
                colors: [Color(hex: "fbc2eb"), Color(hex: "a6c1ee")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fdcbf1"), Color(hex: "e6dee9")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "a1c4fd"), Color(hex: "c2e9fb")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "d299c2"), Color(hex: "fef9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 110), gradient: LinearGradient(
                colors: [Color(hex: "ffecd2"), Color(hex: "fcb69f")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "ff6e7f"), Color(hex: "bfe9ff")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "e0c3fc"), Color(hex: "8ec5fc")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .video(duration: 37), gradient: LinearGradient(
                colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "43e97b"), Color(hex: "38f9d7")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "fa709a"), Color(hex: "fee140")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )),
            MediaItem(type: .photo, gradient: LinearGradient(
                colors: [Color(hex: "30cfd0"), Color(hex: "330867")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        ]
    }

    // MARK: - 选择媒体项

    func selectMediaItem(_ item: MediaItem) {
        selectedMediaItem = item
    }
}
