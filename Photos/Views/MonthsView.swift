/*
月份视图 - 占位实现
*/

import SwiftUI

struct MonthsView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("月份视图")
                    .font(.largeTitle)
                    .bold()

                Text("按月份组织的照片")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("月")
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
    MonthsView()
        .environment(ModelData())
}
