/*
年份视图 - 占位实现
*/

import SwiftUI

struct YearsView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("年份视图")
                    .font(.largeTitle)
                    .bold()

                Text("按年份组织的照片")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("年")
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
    YearsView()
        .environment(ModelData())
}
