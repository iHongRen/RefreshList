# RefreshList

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-orange.svg)](https://developer.harmonyos.com/)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](oh-package.json5)

鸿蒙HarmonyOS NEXT 简单易用的上拉下拉刷新组件，支持自定义样式和多种使用场景。

## 特性

- 支持下拉刷新和上拉加载更多
- 支持自定义刷新头部和底部样式
- 支持普通列表和分组列表
- 支持自定义 HeaderView
- 灵活的配置选项
- 轻量级，易于集成

  

## 安装

### 通过 ohpm 安装

```bash
ohpm install @cxy/refreshlist
```

### 依赖

在项目的 `oh-package.json5` 文件中添加依赖，然后同步：

```json5
{
  "dependencies": {
    "@cxy/refreshlist": "^1.0.0"
  }
}
```

## 快速开始

### 基本用法

```typescript
import { RefreshList, RefreshDataSource, RefreshController } from 'refreshlist'

@Component
struct MyPage {
  @State dataSource: RefreshDataSource = new RefreshDataSource()
  @State controller: RefreshController = new RefreshController()

  build() {
    RefreshList({
      dataSource: this.dataSource,
      controller: this.controller,
      onRefresh: () => this.handleRefresh(),
      onLoadMore: () => this.handleLoadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item),
      keyGenerator: (item: any) => item.id
    })
  }

  @Builder
  itemLayout(item: any): void {
    ListItem() {
      Text(item.title)
        .padding(15)
    }
  }

  handleRefresh() {
    // 处理下拉刷新逻辑
    setTimeout(() => {
      // 更新数据
      this.controller.finishRefresh()
    }, 2000)
  }

  handleLoadMore() {
    // 处理上拉加载更多逻辑
    setTimeout(() => {
      // 加载更多数据
      this.controller.finishRefresh()
    }, 2000)
  }
}
```

## API 文档

### RefreshList 组件属性

| 属性 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| dataSource | RefreshDataSource | 是 | - | 数据源 |
| controller | RefreshController | 是 | - | 控制器 |
| onRefresh | () => void | 否 | - | 下拉刷新回调 |
| onLoadMore | () => void | 否 | - | 上拉加载更多回调 |
| itemLayout | (item: Object, index: number) => void | 是 | - | 列表项布局 |
| customLayout | (wrap: RefreshItemWrap) => void | 否 | - | 自定义布局 |
| headerLayout | () => void | 否 | - | 头部布局 |
| loadingLayout | () => void | 否 | - | 加载中布局 |
| emptyLayout | () => void | 否 | - | 空数据布局 |
| refreshHeaderLayout | (headerData: RefreshHeaderData) => void | 否 | - | 自定义刷新头部 |
| refreshFooterLayout | (footerData: RefreshFooterData) => void | 否 | - | 自定义刷新底部 |
| showLoading | boolean | 否 | true | 是否显示加载状态 |
| showEmpty | boolean | 否 | true | 是否显示空数据状态 |
| cachedCount | number | 否 | 4 | 缓存的列表项数量 |
| divider | ListDivider | 否 | - | 分割线样式 |
| keyGenerator | (item: any) => string | 否 | - | 列表项唯一标识生成器 |

### RefreshController 方法

| 方法 | 参数 | 说明 |
|------|------|------|
| finishRefresh | () => void | 结束刷新状态 |
| setHasmore | (hasmore: boolean) => void | 设置是否还有更多数据 |
| hideLoadMore | (hide: boolean) => void | 隐藏/显示加载更多 |
| onRefresh | () => void | 手动触发下拉刷新 |
| scrollToIndex | (index: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) => void | 滚动到指定位置 |

### RefreshDataSource

数据源类，继承自 BasicDataSource，用于管理列表数据。

### RefreshGroupDataSource

分组数据源类，用于管理分组列表数据。

### RefreshGroupModel

分组数据模型，包含分组标题和子项数据源。

## 使用示例

### 1. 普通列表

```typescript
@Component
struct SimpleList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      divider: { strokeWidth: 1, color: '#ddd' },
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Text(item.title)
        .fontColor('#333')
        .fontSize(15)
        .padding(15)
    }
  }
}
```

### 2. 分组列表

```typescript
@Component
struct GroupList {
  @State viewModel: GroupViewModel = new GroupViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (group: Object, index: number) => this.groupLayout(group as RefreshGroupModel),
      keyGenerator: (group: RefreshGroupModel) => group.title
    })
  }

  @Builder
  groupLayout(group: RefreshGroupModel): void {
    ListItemGroup({ header: this.sectionHeader(group) }) {
      LazyForEach(group.dataSource, (item: ItemModel, index: number) => {
        ListItem() {
          Text(item.title)
            .fontColor('#333')
            .fontSize(15)
            .padding(15)
        }
      }, (item: ItemModel) => item.id)
    }
  }

  @Builder
  sectionHeader(group: RefreshGroupModel): void {
    Text(group.title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .padding(10)
      .backgroundColor('#f5f5f5')
  }
}
```

### 3. 带 HeaderView 的列表

```typescript
@Component
struct HeaderList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      headerLayout: () => this.headerLayout(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  headerLayout(): void {
    Text('我是 Header')
      .textAlign(TextAlign.Center)
      .fontColor('#fff')
      .fontSize(20)
      .backgroundColor('#00a0ff')
      .width('100%')
      .height(200)
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Text(item.title)
        .fontColor('#333')
        .fontSize(15)
        .padding(15)
    }
  }
}
```

### 4. 自定义刷新样式

```typescript
@Component
struct CustomRefreshList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      refreshHeaderLayout: (headerData: RefreshHeaderData) => this.customRefreshHeader(headerData),
      refreshFooterLayout: (footerData: RefreshFooterData) => this.customRefreshFooter(footerData),
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  customRefreshHeader(headerData: RefreshHeaderData): void {
    Row() {
      LoadingProgress()
        .width(20)
        .height(20)
        .visibility(headerData.refreshing ? Visibility.Visible : Visibility.Hidden)
      
      Text(headerData.refreshing ? '正在刷新...' : '下拉刷新')
        .fontSize(14)
        .fontColor('#666')
        .margin({ left: 8 })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(60)
  }

  @Builder
  customRefreshFooter(footerData: RefreshFooterData): void {
    if (!footerData.hide) {
      Row() {
        if (footerData.state === RefreshFooterState.Loading) {
          LoadingProgress()
            .width(16)
            .height(16)
          Text('加载中...')
            .fontSize(12)
            .fontColor('#666')
            .margin({ left: 8 })
        } else {
          Text(footerData.state)
            .fontSize(12)
            .fontColor('#999')
        }
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(50)
    }
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Text(item.title)
        .fontColor('#333')
        .fontSize(15)
        .padding(15)
    }
  }
}
```

## 项目结构

```
RefreshList/
├── AppScope/                 # 应用配置
├── entry/                    # 示例应用
│   └── src/main/ets/pages/   # 示例页面
│       ├── simple/           # 普通列表示例
│       ├── group/            # 分组列表示例
│       ├── header/           # HeaderView 示例
│       └── custom/           # 自定义示例
├── refreshlist/              # 组件库源码
│   └── src/main/ets/refreshlist/
│       ├── RefreshList.ets           # 主组件
│       ├── RefreshController.ets     # 控制器
│       ├── RefreshDataSource.ets     # 数据源
│       ├── RefreshGroupDataSource.ets # 分组数据源
│       ├── RefreshState.ets          # 状态定义
│       ├── RefreshHeader.ets         # 刷新头部
│       ├── RefreshFooter.ets         # 刷新底部
│       ├── RefreshEmptyView.ets      # 空数据视图
│       └── RefreshLoadingView.ets    # 加载视图
└── README.md
```



# 作者

[@仙银](https://github.com/iHongRen) 鸿蒙相关开源作品

1、[hpack](https://github.com/iHongRen/hpack) - 鸿蒙内部测试分发，一键脚本打包工具

2、[Open-in-DevEco-Studio](https://github.com/iHongRen/Open-in-DevEco-Studio)  - macOS 直接在 Finder 工具栏上，使用
DevEco-Studio 打开鸿蒙工程。

3、[cxy-theme](https://github.com/iHongRen/cxy-theme) - DevEco-Studio 绿色背景主题

4、[harmony-udid-tool](https://github.com/iHongRen/harmony-udid-tool) - 简单易用的 HarmonyOS 设备 UDID 获取工具，适用于非开发人员。

5、[SandboxFinder](https://github.com/iHongRen/SandboxFinder) - 鸿蒙沙箱文件浏览器

6、[WebServer](https://github.com/iHongRen/WebServer) - 鸿蒙轻量级Web服务器框架

7、[SelectableMenu](https://github.com/iHongRen/SelectableMenu) - 适用于聊天对话框中的文本选择菜单

8、[RefreshList](https://github.com/iHongRen/RefreshList) - 简单易用的上拉下拉加载组件，自带 Loading 和空页面

🌟 如果项目对你有帮助，欢迎持续关注和 Star ，[赞助](https://ihongren.github.io/donate.html)