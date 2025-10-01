# Photo Gallery - SwiftUI MVVM

基于 SwiftUI 和 MVVM 架构的现代简约风格图库应用，采用 iOS 26 Liquid Glass 设计规范。

## 项目结构

```
Photos/
├── Models/
│   └── MediaItem.swift          # 数据模型（媒体项、媒体类型、Tab 项）
├── ViewModels/
│   └── PhotoGalleryViewModel.swift  # 视图模型（业务逻辑和状态管理）
├── Views/
│   ├── PhotoGalleryView.swift    # 主视图（整合所有组件）
│   ├── PhotoGridView.swift       # 网格视图
│   ├── PhotoItemView.swift       # 单个照片/视频项
│   ├── NavigationBarView.swift   # 导航栏
│   └── TabBarView.swift          # 底部 Tab Bar
└── PhotosApp.swift               # 应用入口
```

## 🎨 Liquid Glass 设计系统

### 核心特性
参考 iOS 26 Liquid Glass 设计规范，实现了全面的毛玻璃材质系统：

#### 1. 动态材质系统
- **Glass 状态**: 使用 `.ultraThinMaterial` 创造透明毛玻璃效果
- **Solid 状态**: 纯色背景，提供清晰的视觉分隔
- **智能切换**: 根据滚动位置自动切换状态

#### 2. NavigationBar (Liquid Glass)
- **两种状态**:
  - **Glass**: 完全透明的毛玻璃效果（0-100pt）
  - **Solid**: 不透明白色背景 + 分隔线 + 阴影（>100pt）
- **SF Symbols**: 使用系统图标（`line.3.horizontal`）
- **状态协调**: 与 TabBar 协调一致的状态切换

#### 3. TabBar (Liquid Glass)
- **两种状态**:
  - **Glass**: `.ultraThinMaterial` 毛玻璃效果（0-200pt）
  - **Solid**: 纯白色背景 + 顶部分隔线（>200pt）
- **三个 Tab**: 图库、精选集、搜索
- **分层设计**: 内容可延伸到 TabBar 下方
- **平滑过渡**: 0.3 秒 easeInOut 动画

#### 4. 详情页工具栏
- **透明背景**: `.toolbarBackground(.hidden)`
- **Glass 按钮**: 圆形毛玻璃容器
- **功能按钮**:
  - 返回按钮（`chevron.left`）
  - 分享按钮（`square.and.arrow.up`）
  - 更多菜单（`ellipsis.circle`）

### 滚动交互逻辑

```swift
// NavigationBar: 0-30pt Glass → >30pt Solid
// TabBar: 0-80pt Glass → >80pt Solid
// 渐进式状态切换，创造流畅的视觉体验
// 降低阈值让效果更明显，用户轻轻滚动即可看到变化
```

### 视觉增强
- **背景色**: 使用 `.systemGroupedBackground` 浅灰背景，让 Glass 效果更明显
- **透明度**: Glass 状态使用 `.ultraThinMaterial` + 微透明度
- **安全区域**: NavigationBar 完全适配刘海屏安全区域
- **实时响应**: 滚动检测优化，状态切换更流畅

## 主要功能

### 1. 响应式网格布局
- iPhone（小屏）: 3 列
- iPhone（大屏）: 4 列
- iPad: 6 列

### 2. 媒体项
- 支持照片和视频
- 视频显示时长标签
- 点击动画效果
- 长按缩放效果

### 3. 导航系统
- 点击照片跳转到详情页
- Glass 风格工具栏
- 支持返回导航

## 技术特点

### MVVM 架构
- **Model**: `MediaItem` - 数据模型，包含媒体类型、渐变色等
- **ViewModel**: `PhotoGalleryViewModel` - 管理数据和业务逻辑
- **View**: 各种 SwiftUI 视图组件

### 核心实现
- **滚动检测**: 使用 `PreferenceKey` 监听滚动偏移
- **响应式布局**: 使用 `LazyVGrid` 和 `GridItem`
- **状态管理**: 使用 `@Published` 和 `@StateObject`
- **导航**: 使用 `NavigationStack` 和 `.navigationDestination`

## 使用方式

1. 在 Xcode 中打开项目
2. 选择目标设备（iPhone 或 iPad）
3. 运行项目

## 扩展建议

- 添加真实图片数据源
- 实现照片选择功能
- 添加搜索功能
- 实现精选集管理
- 支持照片编辑
- 添加云同步功能
