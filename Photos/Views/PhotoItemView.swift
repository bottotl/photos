import SwiftUI

// MARK: - 单个照片/视频项视图
struct PhotoItemView: View {
    let mediaItem: MediaItem
    @State private var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                // 渐变背景
                mediaItem.gradient
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 0.3), value: scale)

                // 视频时长标签
                if let duration = mediaItem.videoDuration {
                    Text(duration)
                        .font(.system(size: 11, weight: .medium))
                        .monospacedDigit()
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(4)
                        .padding(4)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .contentShape(Rectangle())
        }
        .aspectRatio(1, contentMode: .fill)
        .onTapGesture {
            // 点击动画
            withAnimation(.easeInOut(duration: 0.1)) {
                scale = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    scale = 1.0
                }
            }
        }
        .onLongPressGesture(minimumDuration: 0.5) {
            // 长按动画
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 1.05
            }
        } onPressingChanged: { pressing in
            if !pressing {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = 1.0
                }
            }
        }
    }
}
