import Foundation
import SwiftUI

// MARK: - 媒体类型
enum MediaType: Hashable {
    case photo
    case video(duration: TimeInterval)
}

// MARK: - 媒体项模型
struct MediaItem: Identifiable, Hashable {
    let id: UUID
    let type: MediaType
    let gradient: LinearGradient

    init(id: UUID = UUID(), type: MediaType, gradient: LinearGradient) {
        self.id = id
        self.type = type
        self.gradient = gradient
    }

    // MARK: - Hashable 实现
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        lhs.id == rhs.id
    }

    var isVideo: Bool {
        if case .video = type {
            return true
        }
        return false
    }

    var videoDuration: String? {
        if case .video(let duration) = type {
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return String(format: "%d:%02d", minutes, seconds)
        }
        return nil
    }
}

// MARK: - Tab 项
enum TabItem: String, CaseIterable {
    case library = "图库"
    case year = "年"
    case month = "月"
    case all = "全部"

    var iconName: String? {
        switch self {
        case .library: return "photo.on.rectangle"
        case .year, .month, .all: return nil
        }
    }
}

// MARK: - Color 扩展 (十六进制支持)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
