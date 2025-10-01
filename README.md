# Photos - SwiftUI 照片应用

基于 SwiftUI 的现代照片应用，采用 iOS 18 Liquid Glass 设计规范和 Apple Landmarks 架构模式。

## 📱 功能特性

### 核心功能
- ✅ **双视图模式**: 图库网格视图 + 精选集相册视图
- ✅ **响应式布局**: 适配 iPhone 和 iPad 不同屏幕尺寸
- ✅ **照片详情页**: 全屏沉浸式照片查看体验
- ✅ **分屏导航**: iPad 使用 NavigationSplitView 侧边栏导航
- ✅ **底部 TabBar**: iPhone 使用 TabView 切换图库和精选集

### 视图组织
- **图库** (Photos Grid): 响应式网格布局展示所有照片
- **精选集** (Albums): 相册网格展示分类集合
- **年** (Years): 按年份组织照片（待实现）
- **月** (Months): 按月份组织照片（待实现）
- **全部** (All): 全部照片列表（待实现）

## 🏗️ 项目架构

参考 Apple Landmarks 示例应用架构，采用现代 SwiftUI 最佳实践：

```
Photos/
├── Models/
│   ├── Constants.swift           # 应用常量（间距、尺寸、网格配置）
│   ├── MediaItem.swift            # 媒体项模型（照片/视频）
│   ├── ModelData.swift            # @Observable 数据管理
│   └── NavigationOptions.swift    # 导航选项枚举
├── Views/
│   ├── PhotosSplitView.swift     # NavigationSplitView 主容器
│   ├── PhotosMainView.swift      # TabView 容器（图库/精选集）
│   ├── PhotosGridView.swift      # 照片网格视图
│   ├── AlbumsGridView.swift      # 相册网格视图
│   ├── PhotoItemView.swift       # 照片单元格
│   ├── FlexibleHeader.swift      # 可伸缩标题
│   ├── YearsView.swift           # 年份视图
│   ├── MonthsView.swift          # 月份视图
│   └── AllPhotosView.swift       # 全部照片视图
└── PhotosApp.swift               # 应用入口

```

### 架构特点

#### 1. @Observable 模式
- 使用 iOS 17+ 的 `@Observable` 宏替代 `ObservableObject`
- 更简洁的状态管理和自动依赖追踪
- `ModelData` 管理应用级数据和导航状态

#### 2. NavigationSplitView
- iPad: 侧边栏 + 详情页双栏布局
- iPhone: 紧凑模式自动收起侧边栏
- 统一的导航路径管理

#### 3. TabView 导航
- 底部 Tab 切换图库和精选集视图
- 使用枚举 `PhotosTab` 管理 Tab 状态
- `.tabItem` 配置图标和标题

#### 4. 响应式设计
- 使用 `@Environment(\.horizontalSizeClass)` 检测设备类型
- iPad: 6 列网格
- iPhone 大屏: 4 列网格
- iPhone 小屏: 3 列网格

## 🎨 Liquid Glass 设计系统

参考 iOS 18 的 Liquid Glass 设计规范：

### 视觉特性
- **毛玻璃材质**: 使用 `.ultraThinMaterial` 创造通透效果
- **动态模糊**: 背景内容透过玻璃材质可见
- **层次分明**: 内容、玻璃层、背景的清晰层次

### 应用实例

#### NavigationBar
- 使用 `.toolbar` API 添加工具栏按钮
- 系统自动应用 iOS 18 玻璃效果
- 按钮自动获得 `.ultraThinMaterial` 背景

#### 照片详情页
- 透明导航栏：`.toolbarBackground(.hidden)`
- Glass 按钮：圆形毛玻璃容器
- 功能按钮：
  - 返回 (`chevron.left`)
  - 分享 (`square.and.arrow.up`)
  - 更多 (`ellipsis.circle`)

#### TabBar
- 系统原生 TabView 自动应用玻璃效果
- 图库和精选集两个 Tab
- 使用 SF Symbols 图标

## 🔧 技术实现

### SwiftUI 特性
- **@Observable**: 现代状态管理
- **@Environment**: 环境依赖注入
- **@Bindable**: 双向绑定支持
- **NavigationPath**: 类型安全的导航栈
- **LazyVGrid**: 高性能网格布局
- **.onGeometryChange**: 几何变化监听

### 核心组件

#### Constants
```swift
struct Constants {
    static let cornerRadius: CGFloat = 15.0
    static let photoGridSpacing: CGFloat = 2.0
    @MainActor static var photoGridItemMinSize: CGFloat {
        // iPad: 160pt, iPhone: 120pt
    }
}
```

#### ModelData
```swift
@Observable @MainActor
class ModelData {
    var mediaItems: [MediaItem] = []
    var selectedMediaItem: MediaItem? = nil
    var searchString: String = ""
    var path: NavigationPath = NavigationPath()
    var windowSize: CGSize = .zero
}
```

#### NavigationOptions
```swift
enum NavigationOptions: Equatable, Hashable, Identifiable {
    case photos, years, months, all

    @MainActor @ViewBuilder func viewForPage() -> some View {
        switch self {
        case .photos: PhotosMainView()
        case .years: YearsView()
        // ...
        }
    }
}
```

## 🚀 使用方式

### 运行项目
1. 使用 Xcode 16+ 打开 `Photos.xcodeproj`
2. 选择目标设备（iPhone 16 或 iPad）
3. 运行项目 (⌘R)

### 构建要求
- **Xcode**: 16.0+
- **iOS**: 18.0+
- **Swift**: 5.10+

## 📖 参考资源

### Apple 官方文档
- [Landmarks Sample App](https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation)
- [Liquid Glass Design](https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass)
- [Observable Macro](https://developer.apple.com/documentation/Observation)
- [NavigationSplitView](https://developer.apple.com/documentation/swiftui/navigationsplitview)

### WWDC Sessions
- WWDC 2024: What's new in SwiftUI
- WWDC 2024: Adopt the Liquid Glass design system

## 🎯 下一步开发

### 即将实现
- [ ] 真实照片数据源（PhotoKit 集成）
- [ ] 照片选择模式
- [ ] 搜索功能实现
- [ ] 精选集管理（创建、删除、编辑）
- [ ] 年/月时间轴视图
- [ ] 照片元数据展示

### 未来规划
- [ ] 照片编辑功能
- [ ] iCloud 同步
- [ ] 共享相册
- [ ] 智能分类（人物、地点、事物）
- [ ] 回忆和精选照片
- [ ] 导出和分享优化

## 📄 许可证

本项目仅供学习和参考使用。
