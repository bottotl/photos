# Claude Code GitHub Actions 指导文件

当在 GitHub Actions 中运行时,请遵循以下指导:

## 项目特定规范

### 代码审查重点

1. **架构一致性**:
   - 确保遵循 Landmarks 架构模式
   - 验证使用 `@Observable` 而非 `@Published`
   - 检查 `ModelData` 状态管理是否正确
   - 确认 NavigationSplitView/TabView 层级结构

2. **SwiftUI 最佳实践**:
   - 使用 `@Environment(ModelData.self)` 而非 `@EnvironmentObject`
   - 所有 UI 相关代码标记 `@MainActor`
   - Preview 使用 `@Previewable @State` 模式
   - 使用 MARK 注释组织代码

3. **命名和注释**:
   - 所有注释使用中文
   - 文件头注释说明用途和架构参考
   - 遵循 Swift 命名规范(camelCase)

4. **iOS 26 Liquid Glass 特性**:
   - 使用 Liquid Glass 动态材质系统
   - 应用 Lensing 效果(动态弯曲和聚焦光线)
   - 使用 `.toolbar` API 自动应用玻璃效果
   - 利用 `.onGeometryChange` 响应几何变化
   - 系统 TabView 自动应用 Liquid Glass 材质

### 审查清单

**必须检查**:
- [ ] 是否违反 CLAUDE.md 中的架构规则
- [ ] 是否正确使用 `@Observable` 模式
- [ ] 是否破坏 NavigationSplitView 层级
- [ ] 是否有硬编码的尺寸(应使用 Constants)
- [ ] 是否缺少中文注释
- [ ] 是否正确应用 Liquid Glass 材质
- [ ] 是否使用过时的 SwiftUI API

**建议提供**:
- Swift 6.0 代码风格改进
- 响应式布局优化建议
- 性能优化建议(LazyVGrid, 图片加载等)
- Liquid Glass 材质和 Lensing 效果优化
- iOS 26 新特性应用建议

### 回答风格

- **简洁明了**: 直接指出问题和解决方案
- **代码示例**: 提供具体的代码修改建议
- **中文回复**: 所有回复使用中文
- **技术准确**: 基于 iOS 18 和 Swift 5.10+ 标准

### 常见问题处理

1. **状态管理问题**:
   - 引导使用 `ModelData` 集中管理
   - 避免在视图中直接使用 `@State` 管理应用级状态

2. **导航问题**:
   - 使用 `modelData.path` 进行编程式导航
   - 使用 `.navigationDestination(for: MediaItem.self)`

3. **响应式布局**:
   - 参考现有的 `gridColumns` 计算属性
   - 使用 `@Environment(\.horizontalSizeClass)`

## 使用说明

### PR 审查
创建 PR 后会自动触发审查,无需额外操作。

### 交互式使用
在 Issue 或 PR 评论中使用 `@claude` 提问:

```
@claude 这段代码的性能可以优化吗?
@claude 如何添加一个新的 Tab?
@claude 解释一下 NavigationPath 的工作原理
```

### 代码修改
Claude 可以直接提出代码修改建议,审查后可以直接应用到 PR。
