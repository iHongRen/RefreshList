## 🔄 更新日志

### [v1.1.0](https://github.com/iHongRen/RefreshList/releases/tag/v1.1.0)  (2026-05-29)

#### Bug 修复

- 修复 Footer 可见性逻辑冲突：统一由 `isShow` 控制，移除冗余的双重绑定
- 修复 `notifyDataReload` 未触发 `onDataCountChange`，确保空页面状态正确同步
- 修复 `RefreshGroupDataSource` 类型假设不安全：所有强制类型转换改为 `instanceof` 守卫
- 修复 `showLoading` 异步时序问题：移除 `onDidBuild`，改用 `onDataCountChange` 回调自动切换
- 修复 `deleteIndexCount` 缺少边界检查，防止越界操作导致数据不一致
- 修复 `moveDataIndex` 缺少越界保护，防止运行时异常

#### Breaking Changes

- **拼写修正**：`repalceIndex` 方法重命名为 `replaceIndex`（影响 `RefreshDataSource` 公开 API）
- **拼写修正**：`RefreshListDirvier.ets` 文件重命名为 `RefreshListDivider.ets`
- **拼写修正**：`edfeEffect` 属性重命名为 `edgeEffect`（影响 `RefreshList` 组件属性）
- `RefreshFooterData.isShow` 默认值从 `true` 改为 `false`

#### 功能优化

- README API 文档每个模块独立折叠，优化阅读体验
- `RefreshEmptyView` 硬编码颜色改为可配置属性，支持通过 `RefreshGlobalConfig` 全局自定义
- `RefreshGlobalConfig` 新增空视图颜色配置：`emptyTitleColor`、`emptyDescColor`、`emptyRetryButtonColor`、`emptyRetryTextColor`
- `RefreshList` 内部 `@State` 变量添加 `private` 修饰符，提升封装性

### [v1.0.4](https://github.com/iHongRen/RefreshList/releases/tag/v1.0.4)  (2025-11-22)

- 优化文档
- 新增包签名

### [v1.0.3](https://github.com/iHongRen/RefreshList/releases/tag/v1.0.3)  (2025-11-21)

- 优化文档
- API 兼容性提升到 5.0.3(15)
- 新增参数 refreshOffset: 设置触发刷新的下拉偏移量

### [v1.0.2](https://github.com/iHongRen/RefreshList/releases/tag/v1.0.2)  (2025-11-11)

- API 兼容性提升到 5.0.3(15)
- 新增参数 refreshOffset: 设置触发刷新的下拉偏移量

### [v1.0.1](https://github.com/iHongRen/RefreshList/releases/tag/v1.0.1)  (2025-11-09)

- 支持配置全局刷新footer，empty，loading 组件
- 增加 lottie 用于自定义组件使用demo

### [v1.0.0](https://github.com/iHongRen/RefreshList/releases/tag/v1.0.0)  (2025-09-09)

- 支持下拉刷新和上拉加载更多
- 支持自定义刷新头部和底部组件
- 支持自定义加载中和空页面组件
- 支持自定义 HeaderView 组件
- 支持分组列表
- 支持全局自定义各种组件
- 完善的 [demo](https://github.com/iHongRen/RefreshList) 示例

