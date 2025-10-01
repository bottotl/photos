/*
全部照片视图 - 占位实现
*/

import SwiftUI

struct AllPhotosView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("全部照片")
                    .font(.largeTitle)
                    .bold()

                Text("所有照片的列表视图")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("全部")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("选择") {
                    // 选择操作
                }
            }
        }
    }
}

#Preview {
    AllPhotosView()
        .environment(ModelData())
}
