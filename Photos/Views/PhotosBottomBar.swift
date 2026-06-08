/*
照片底部栏 - 复刻系统照片的单行形态切换控件
*/

import SwiftUI

enum PhotosBottomBarMode: Equatable {
    case library
    case timeline
}

struct PhotosBottomBar: View {
    let mode: PhotosBottomBarMode
    @Binding var selectedTab: PhotosMainView.PhotosTab
    @Binding var timelineFilter: TimelineFilter
    let scrollToBottom: () -> Void
    let search: () -> Void

    private let controlHeight: CGFloat = 64
    private let sideButtonSize: CGFloat = 62
    private let selectedInset: CGFloat = 5
    private let controlSpacing: CGFloat = 10

    var body: some View {
        HStack(spacing: controlSpacing) {
            if mode == .library {
                libraryControl
                    .transition(.blurReplace)

                Spacer(minLength: 0)
            } else {
                circleButton(
                    systemName: "photo.on.rectangle",
                    foregroundStyle: .accentColor,
                    accessibilityLabel: "返回图库底部",
                    action: scrollToBottom
                )
                .transition(.blurReplace)

                timelineControl
                    .transition(.blurReplace)
            }

            circleButton(
                systemName: "magnifyingglass",
                foregroundStyle: .primary,
                accessibilityLabel: "搜索",
                action: search
            )
        }
        .frame(height: controlHeight)
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 0)
        .animation(.snappy(duration: 0.28), value: mode)
        .offset(y: 18)
    }

    // MARK: - 图库/精选集

    private var libraryControl: some View {
        HStack(spacing: 0) {
            libraryTab(
                title: "图库",
                systemName: "photo.on.rectangle",
                isSelected: selectedTab == .grid
            ) {
                selectedTab = .grid
            }

            libraryTab(
                title: "精选集",
                systemName: "rectangle.stack",
                isSelected: selectedTab == .albums
            ) {
                selectedTab = .albums
            }
        }
        .padding(selectedInset)
        .frame(width: 178, height: controlHeight)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    private func libraryTab(
        title: LocalizedStringKey,
        systemName: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: systemName)
                    .font(.system(size: 25, weight: .semibold))

                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
            .background {
                if isSelected {
                    Capsule()
                        .fill(.regularMaterial)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    // MARK: - 年/月/全部

    private var timelineControl: some View {
        HStack(spacing: 0) {
            ForEach(TimelineFilter.allCases) { filter in
                Button {
                    timelineFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.title3.weight(.semibold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(timelineFilter == filter ? .primary : .secondary)
                        .background {
                            if timelineFilter == filter {
                                Capsule()
                                    .fill(.regularMaterial)
                            }
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(filter.rawValue)
            }
        }
        .padding(selectedInset)
        .frame(maxWidth: .infinity)
        .frame(height: controlHeight)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    // MARK: - 圆形按钮

    private func circleButton(
        systemName: String,
        foregroundStyle: Color,
        accessibilityLabel: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: sideButtonSize, height: sideButtonSize)
                .foregroundStyle(foregroundStyle)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .background(.ultraThinMaterial, in: Circle())
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    @Previewable @State var selectedTab: PhotosMainView.PhotosTab = .grid
    @Previewable @State var timelineFilter: TimelineFilter = .all

    VStack {
        Spacer()

        PhotosBottomBar(
            mode: .library,
            selectedTab: $selectedTab,
            timelineFilter: $timelineFilter,
            scrollToBottom: {},
            search: {}
        )

        PhotosBottomBar(
            mode: .timeline,
            selectedTab: $selectedTab,
            timelineFilter: $timelineFilter,
            scrollToBottom: {},
            search: {}
        )
    }
    .background {
        LinearGradient(
            colors: [.cyan, .orange, .mint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
