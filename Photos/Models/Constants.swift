/*
参考 Landmarks 项目的 Constants.swift
为 Photos 应用定义常量值
*/

import SwiftUI

/// Photos 应用的常量定义
struct Constants {
    // MARK: 全局常量

    static let cornerRadius: CGFloat = 15.0
    static let leadingContentInset: CGFloat = 26.0
    static let standardPadding: CGFloat = 14.0
    static let safeAreaPadding: CGFloat = 30.0
    static let titleTopPadding: CGFloat = 8.0
    static let titleBottomPadding: CGFloat = -4.0

    // MARK: 照片网格常量

    static let photoGridSpacing: CGFloat = 2.0  // 照片之间的间距

    @MainActor static var photoGridItemMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 160.0  // iPad 最小尺寸
        } else {
            return 120.0  // iPhone 最小尺寸
        }
        #else
        return 160.0
        #endif
    }

    static let photoGridItemMaxSize: CGFloat = 200.0

    // MARK: 照片详情常量

    static let photoDetailImagePadding: CGFloat = 14.0

    // MARK: 相册网格常量

    static let albumGridSpacing: CGFloat = 14.0

    @MainActor static var albumGridItemMinSize: CGFloat {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 220.0
        } else {
            return 160.0
        }
        #else
        return 220.0
        #endif
    }

    static let albumGridItemMaxSize: CGFloat = 290.0
    static let albumGridItemCornerRadius: CGFloat = 8.0

    // MARK: 视频时长显示

    static let videoDurationPadding: CGFloat = 6.0
    static let videoDurationFontSize: CGFloat = 12.0

    // MARK: 样式

    #if os(macOS)
    static let editingBackgroundStyle = WindowBackgroundShapeStyle.windowBackground
    #else
    static let editingBackgroundStyle = Material.ultraThickMaterial
    #endif
}
