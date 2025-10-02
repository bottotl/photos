/*
参考 Landmarks 项目的 NavigationOptions.swift
Photos 应用的导航选项枚举
*/

import SwiftUI

/// Photos 应用的导航选项枚举
enum NavigationOptions: Equatable, Hashable, Identifiable {
    /// 照片网格视图
    case photos
    /// 年份视图
    case years
    /// 月份视图
    case months
    /// 全部视图
    case all

    static let mainPages: [NavigationOptions] = [.photos]

    var id: String {
        switch self {
        case .photos: return "Photos"
        case .years: return "Years"
        case .months: return "Months"
        case .all: return "All"
        }
    }

    var name: LocalizedStringResource {
        switch self {
        case .photos: LocalizedStringResource("图库")
        case .years: LocalizedStringResource("年")
        case .months: LocalizedStringResource("月")
        case .all: LocalizedStringResource("全部")
        }
    }

    var symbolName: String {
        switch self {
        case .photos: "photo.on.rectangle"
        case .years: "calendar"
        case .months: "calendar.day.timeline.left"
        case .all: "square.grid.2x2"
        }
    }

    /// 为选中的导航选项返回对应的视图
    @MainActor @ViewBuilder func viewForPage() -> some View {
        switch self {
        case .photos: PhotosMainView()
        case .years: YearsView()
        case .months: MonthsView()
        case .all: AllPhotosView()
        }
    }
}
