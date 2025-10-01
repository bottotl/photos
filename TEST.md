# Claude Code Actions 测试

这是一个测试文件,用于验证 Claude Code GitHub Actions 集成。

## 测试目标

1. ✅ PR 创建时自动触发 Claude Code
2. ✅ Claude Code 自动审查代码
3. ✅ 在评论中使用 `@claude` 可以交互

## 预期行为

- Claude 应该自动分析这个 PR
- 可以在评论中询问 Claude 问题
- Claude 可以提供代码建议

## 测试问题

这个文件故意包含一些可以让 Claude 评论的内容:
- 这是一个新的 Markdown 文件
- 测试 Claude 是否能识别文档结构
- 验证 OAuth token 认证是否正常工作
