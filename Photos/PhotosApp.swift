/*
Photos 应用主入口 - 参考 Landmarks 架构
使用 NavigationSplitView + ModelData 模式
*/

import SwiftUI

@main
struct PhotosApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            PhotosSplitView()
                .environment(modelData)
                .frame(minWidth: 375.0, minHeight: 375.0)
                .onGeometryChange(for: CGSize.self) { geometry in
                    geometry.size
                } action: {
                    modelData.windowSize = $0
                }
        }
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
