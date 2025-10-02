/*
时间线筛选视图 - 年月全部选择器
*/

import SwiftUI

/// 时间线筛选选择器
struct TimelineFilterView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimelineFilter.allCases) { filter in
                Button {
                    withAnimation {
                        modelData.timelineFilter = filter
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: filter.iconName)
                            .font(.system(size: 20))
                        Text(filter.rawValue)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(modelData.timelineFilter == filter ? .blue : .primary)
                }
            }
        }
        .frame(height: 49)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    @Previewable @State var modelData = ModelData()

    TimelineFilterView()
        .environment(modelData)
}
