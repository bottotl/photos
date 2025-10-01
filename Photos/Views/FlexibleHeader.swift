/*
参考 Landmarks 项目的 FlexibleHeader.swift
实现滚动时头部内容的拉伸效果
*/

import SwiftUI

@Observable private class FlexibleHeaderGeometry {
    var offset: CGFloat = 0
}

/// 视图修饰符 - 当包含的几何偏移量变化时拉伸内容
private struct FlexibleHeaderContentModifier: ViewModifier {
    @Environment(ModelData.self) private var modelData
    @Environment(FlexibleHeaderGeometry.self) private var geometry

    func body(content: Content) -> some View {
        let height = (modelData.windowSize.height / 2) - geometry.offset
        content
            .frame(height: height)
            .padding(.bottom, geometry.offset)
            .offset(y: geometry.offset)
    }
}

/// 视图修饰符 - 跟踪滚动视图几何形状以拉伸使用 FlexibleHeaderContentModifier 的视图
private struct FlexibleHeaderScrollViewModifier: ViewModifier {
    @State private var geometry = FlexibleHeaderGeometry()

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                min(geometry.contentOffset.y + geometry.contentInsets.top, 0)
            } action: { _, offset in
                geometry.offset = offset
            }
            .environment(geometry)
    }
}

// MARK: - View Extensions

extension ScrollView {
    /// 应用 FlexibleHeaderScrollViewModifier 后返回视图
    @MainActor func flexibleHeaderScrollView() -> some View {
        modifier(FlexibleHeaderScrollViewModifier())
    }
}

extension View {
    /// 应用 FlexibleHeaderContentModifier 后返回视图
    func flexibleHeaderContent() -> some View {
        modifier(FlexibleHeaderContentModifier())
    }
}
