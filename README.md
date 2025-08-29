# RefreshList

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-orange.svg)](https://developer.harmonyos.com/)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](oh-package.json5)

鸿蒙HarmonyOS NEXT 简单易用的上拉下拉刷新组件，支持自定义样式和多种使用场景。



## ✨ 特性

- 支持下拉刷新和上拉加载更多
- 支持自定义刷新头部和底部样式
- 支持自定义加载和空数据状态
- 支持自定义 HeaderView
- 支持分组列表
- 灵活的配置选项和属性修饰器
- 轻量级，易于集成



## 📦 安装

### 通过 ohpm 安装

```bash
ohpm install @cxy/refreshlist
```

### 本地依赖

在项目的 `oh-package.json5` 文件中添加依赖：

```json5
{
  "dependencies": {
    "@cxy/refreshlist": "^1.0.0"
  }
}
```



## 🚀 快速开始指南

### 1. 创建数据模型

```typescript
// ItemModel.ets
export class ItemModel {
  id: string = ''
  title: string = ''

  constructor(id: string, title: string) {
    this.id = id
    this.title = title
  }
}
```

### 2. 创建ViewModel

```typescript
// SimpleViewModel.ets
import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "./ItemModel"

export class SimpleViewModel {
  @Track dataSource: RefreshDataSource = new RefreshDataSource
  @Track controller: RefreshController = new RefreshController()
  private curpage: number = 1

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.curpage + 1)
  }

  async requestData(page: number): Promise<void> {
    // 模拟网络请求
    setTimeout(() => {
      const count = page === 1 ? 0 : this.dataSource.totalCount()
      const list = this.generateData(count)
      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(list)

      // 是否还有更多数据
      const hasmore = this.dataSource.totalCount() < 50
      this.controller.setHasmore(hasmore)
      this.controller.finishRefresh()

      this.curpage = page
    }, 500)
  }

  private generateData(count: number): ItemModel[] {
    const list: ItemModel[] = []
    for (let i = 0; i < 20; i++) {
      const item = new ItemModel(`${count + i}`, `item${count + i}`)
      list.push(item)
    }
    return list
  }
}
```

### 3. 使用组件

```typescript
// MyPage.ets
import { RefreshList } from '@cxy/refreshlist'
import { SimpleViewModel } from './SimpleViewModel'
import { ItemModel } from './ItemModel'

@Component
struct MyPage {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  aboutToAppear() {
    this.viewModel.refresh()
  }

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      keyGenerator: (item: ItemModel) => item.id //设置唯一key
    })
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Text(item.title)
        .fontSize(16)
        .padding(15)
    }
  }
}
```




## 📚 API 文档

### RefreshList 组件属性

#### 必需属性

| 属性 | 类型 | 说明 |
|------|------|------|
| dataSource | RefreshDataSource \| RefreshGroupDataSource | 数据源，管理列表数据 |
| controller | RefreshController | 控制器，用于控制刷新状态和列表操作 |

#### 布局属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| itemLayout | (item: ESObject, index: number) => void | - | 列表项布局 |
| customLayout | () => void | - | 自定义布局，完全自定义LazyForEach部分 |
| headerLayout | () => void | - | 列表头部布局，类似iOS的tableHeaderView |
| loadingLayout | () => void | 默认加载视图 | 加载中状态的布局 |
| emptyLayout | () => void | 默认空视图 | 空数据状态的布局 |
| refreshHeaderLayout | () => void | 默认刷新头部 | 自定义下拉刷新头部布局 |
| refreshFooterLayout | () => void | 默认刷新底部 | 自定义上拉加载底部布局 |

#### 状态属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| showLoading | boolean | true | 是否显示加载状态 |
| showEmpty | boolean | true | 是否显示空数据状态 |

#### 列表配置属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| cachedCount | number | 4 | 缓存的列表项数量，用于性能优化，建议使用列表能显示列表项的一半 |
| contentStartOffset | number | 0 | 设置内容区域起始偏移量 |
| contentEndOffset | number | 0 | 设置内容区末尾偏移量 |
| sticky | StickyStyle | StickyStyle.Header \| StickyStyle.Footer | 吸顶样式 |
| itemSpace | number | 0 | 列表项间距 |
| barState | BarState | BarState.On | 滚动条状态 |
| pullDownRatio | number | 0.62 | 设置下拉跟手系数，禁止下拉设置0 |
| divider | RefreshListDivider \| null | null | 分割线样式 |
| lanes | number | 1 | 设置List组件的布局列数或行数 |
| gutter | Dimension | 0 | 列间距 |
| maintainVisibleContentPosition | boolean | false | 插入或删除数据时是否保持可见内容位置不变 |
| edfeEffect | EdgeEffect | EdgeEffect.Spring | List的EdgeEffect效果 |
| listAttrModifier | RefreshListAttrModifier | new RefreshListAttrModifier() | 用于自定义更多List属性 |

#### 回调函数

| 属性 | 类型 | 说明 |
|------|------|------|
| onRefresh | () => void | 下拉刷新时的回调函数 |
| onLoadMore | () => void | 上拉加载更多时的回调函数 |
| keyGenerator | (item: ESObject, index: number) => string | 列表项唯一标识生成器 |
| onDidScroll | OnScrollCallback | 滚动时的回调函数 |
| onReachEnd | () => void | 滚动到底部时的回调函数 |
| onScrollIndex | (start: number, end: number) => void | 滚动到索引时的回调函数 |

### RefreshController 控制器

RefreshController 提供了控制刷新列表的各种方法：

#### 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| scroller | ListScroller | 列表滚动控制器 |

#### 方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| finishRefresh | () | void | 结束刷新状态，必须在刷新完成后调用 |
| setHasmore | (hasmore: boolean) | void | 设置是否还有更多数据可加载 |
| hideLoadMore | (hide: boolean) | void | 隐藏或显示加载更多组件 |
| onRefresh | () | void | 手动触发下拉刷新 |
| scrollToIndex | (index: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) | void | 滚动到指定索引位置 |

### RefreshDataSource 数据源

RefreshDataSource 是管理列表数据的核心类，实现了 IDataSource 接口：

#### 基础方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| isEmpty | () | boolean | 判断数据源是否为空 |
| totalCount | () | number | 获取数据总数 (分组时，为分组数量) |
| totalItemCount | () | number | 获取数据项总数（分组时，为分组下item总数） |
| getData | (index: number) | Object \| undefined | 获取指定索引的数据 |
| getLastData | () | Object \| undefined | 获取最后一项数据 |
| getDataAll | () | Object[] | 获取所有数据的副本 |

#### 数据操作方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| insertData | (index: number, data: Object) | void | 在指定位置插入单个数据 |
| insertDataArray | (index: number, arr: Object[]) | void | 在指定位置插入数据数组 |
| pushData | (data: Object) | void | 在末尾添加单个数据 |
| pushDataArray | (arr: Object[]) | void | 在末尾添加数据数组 |
| deleteIndex | (index: number) | void | 删除指定索引的数据 |
| deleteData | (data: Object) | void | 删除指定数据对象 |
| deleteAll | () | void | 删除所有数据 |
| deleteIndexCount | (index: number, count: number) | void | 从指定索引开始删除指定数量的数据 |
| repalceIndex | (index: number, data: Object, key?: string) | void | 替换指定索引的数据 |
| reloadIndex | (index: number, key?: string) | void | 重新加载指定索引的数据 |
| reloadData | (data: Object, key?: string) | void | 重新加载指定数据对象 |
| reloadDataAll | () | void | 重新加载所有数据 |
| moveDataIndex | (from: number, to: number) | void | 移动数据从一个位置到另一个位置 |

#### 监听器方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| registerDataChangeListener | (listener: DataChangeListener) | void | 注册数据变化监听器 |
| unregisterDataChangeListener | (listener: DataChangeListener) | void | 取消注册数据变化监听器 |

#### 回调属性

| 属性 | 类型 | 说明 |
|------|------|------|
| onDataCountChange | (count: number) => void | 数据数量变化时的回调 |

### RefreshGroupDataSource 分组数据源

RefreshGroupDataSource 继承自 RefreshDataSource，专门用于管理分组列表数据：

#### 重写方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| isEmpty | () | boolean | 判断分组数据源是否为空 |
| totalItemCount | () | number | 计算所有分组中的数据项总数 |
| getGroupDataAll | () | Object[] | 获取所有分组中的数据项 |

#### 分组特有方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| addListToGroup | (list: Object[], getTitle: (e: ESObject) => string) | void | 将数据列表按标题分组添加 |

### RefreshGroupModel 分组模型

分组数据的模型类：

#### 属性

| 属性 | 类型 | 说明 |
|------|------|------|
| title | string | 分组标题 |
| dataSource | RefreshDataSource | 分组内的数据源 |
| data | Object | 可选的附加数据 |

#### 构造函数

```typescript
constructor(title: string, dataSource: RefreshDataSource)
```

### RefreshHeaderData 刷新头部数据

下拉刷新头部的状态数据：

| 属性 | 类型 | 说明 |
|------|------|------|
| refreshState | RefreshStatus | 刷新状态（Inactive、Drag、OverDrag、Refresh、Done） |
| refreshOffset | number | 下拉偏移量 |
| refreshing | boolean | 是否正在刷新 |

### RefreshFooterData 刷新底部数据

上拉加载更多底部的状态数据：

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| isShow | boolean | true | 是否显示底部组件 |
| state | RefreshFooterState | RefreshFooterState.Done | 加载状态 |
| loadingText | string | '加载中...' | 加载中显示的文本 |
| doneText | string | '加载完成' | 加载完成显示的文本 |
| noMoreText | string | '亲，没有更多了' | 没有更多数据时显示的文本 |

#### 方法

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| footerText | () | string | 根据当前状态返回对应的文本 |

### RefreshFooterState 枚举

加载更多的状态枚举：

| 值 | 数值 | 说明 |
|------|------|------|
| Loading | 0 | 正在加载中 |
| Done | 1 | 加载完成 |
| NoMore | 2 | 没有更多数据 |

### RefreshListDivider 分割线接口

自定义分割线样式的接口：

| 属性 | 类型 | 必需 | 说明 |
|------|------|------|------|
| strokeWidth | Length | 是 | 分割线宽度 |
| color | ResourceColor | 否 | 分割线颜色 |
| startMargin | Length | 否 | 起始边距 |
| endMargin | Length | 否 | 结束边距 |

### RefreshListAttrModifier 属性修饰器

用于自定义更多List属性的修饰器类：

```typescript
export class RefreshListAttrModifier implements AttributeModifier<ListAttribute> {
  applyNormalAttribute(instance: ListAttribute): void {
    // 在这里可以自定义更多List属性
  }
}
```



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
import { RefreshList, RefreshHeaderData, RefreshFooterData, RefreshFooterState } from 'refreshlist'

@Component
struct CustomRefreshList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()
  @State refreshHeaderData: RefreshHeaderData = new RefreshHeaderData()
  @State refreshFooterData: RefreshFooterData = new RefreshFooterData()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      refreshHeaderLayout: () => this.customRefreshHeader(),
      refreshFooterLayout: () => this.customRefreshFooter(),
      loadingLayout: () => this.customLoadingLayout(),
      emptyLayout: () => this.customEmptyLayout(),
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  customRefreshHeader(): void {
    Row() {
      LoadingProgress()
        .width(20)
        .height(20)
        .visibility(this.refreshHeaderData.refreshing ? Visibility.Visible : Visibility.Hidden)
      
      Text(this.refreshHeaderData.refreshing ? '正在刷新...' : '下拉刷新')
        .fontSize(14)
        .fontColor('#666')
        .margin({ left: 8 })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(60)
  }

  @Builder
  customRefreshFooter(): void {
    if (this.refreshFooterData.isShow) {
      Row() {
        if (this.refreshFooterData.state === RefreshFooterState.Loading) {
          LoadingProgress()
            .width(16)
            .height(16)
          Text(this.refreshFooterData.loadingText)
            .fontSize(12)
            .fontColor('#666')
            .margin({ left: 8 })
        } else {
          Text(this.refreshFooterData.footerText())
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
  customLoadingLayout(): void {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
      Text('加载中...')
        .fontSize(16)
        .fontColor('#666')
        .margin({ top: 10 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  @Builder
  customEmptyLayout(): void {
    Column() {
      Image($r('app.media.empty_icon'))
        .width(100)
        .height(100)
      Text('暂无数据')
        .fontSize(16)
        .fontColor('#999')
        .margin({ top: 20 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
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

### 5. 完全自定义布局

```typescript
@Component
struct FullCustomList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      customLayout: () => this.customLayout(),
      headerLayout: () => this.headerLayout(),
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  customLayout(): void {
    // 完全自定义LazyForEach部分
    LazyForEach(this.viewModel.dataSource, (item: ItemModel, index: number) => {
      ListItem() {
        Row() {
          Image(item.avatar)
            .width(50)
            .height(50)
            .borderRadius(25)
          
          Column() {
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
            Text(item.subtitle)
              .fontSize(14)
              .fontColor('#666')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
          .layoutWeight(1)
          
          Text(item.time)
            .fontSize(12)
            .fontColor('#999')
        }
        .width('100%')
        .padding(15)
        .alignItems(VerticalAlign.Center)
      }
    }, (item: ItemModel) => item.id)
  }

  @Builder
  headerLayout(): void {
    Column() {
      Image($r('app.media.banner'))
        .width('100%')
        .height(200)
        .objectFit(ImageFit.Cover)
      
      Text('欢迎使用RefreshList')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding(20)
    }
  }
}
```

### 6. 高级配置示例

```typescript
@Component
struct AdvancedRefreshList {
  @State viewModel: SimpleViewModel = new SimpleViewModel()
  @State controller: RefreshController = new RefreshController()
  private customAttrModifier: RefreshListAttrModifier = new RefreshListAttrModifier()

  aboutToAppear() {
    // 自定义属性修饰器
    this.customAttrModifier.applyNormalAttribute = (instance: ListAttribute) => {
      instance.backgroundColor('#f5f5f5')
      instance.borderRadius(10)
      instance.padding(10)
    }
  }

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.controller,
      onRefresh: () => this.handleRefresh(),
      onLoadMore: () => this.handleLoadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      
      // 高级配置
      cachedCount: 10,                    // 缓存更多项目
      itemSpace: 8,                       // 项目间距
      lanes: 2,                          // 两列布局
      gutter: 10,                        // 列间距
      pullDownRatio: 0.8,                // 下拉跟手系数
      maintainVisibleContentPosition: true, // 保持可见内容位置
      edfeEffect: EdgeEffect.Fade,       // 边缘效果
      barState: BarState.Auto,           // 滚动条自动显示
      listAttrModifier: this.customAttrModifier, // 自定义属性修饰器
      
      // 分割线配置
      divider: {
        strokeWidth: 1,
        color: '#e0e0e0',
        startMargin: 15,
        endMargin: 15
      },
      
      // 回调函数
      onDidScroll: (scrollOffset: number, scrollState: ScrollState) => {
        console.log(`滚动偏移: ${scrollOffset}, 状态: ${scrollState}`)
      },
      onReachEnd: () => {
        console.log('到达列表底部')
      },
      onScrollIndex: (start: number, end: number) => {
        console.log(`可见范围: ${start} - ${end}`)
      },
      
      keyGenerator: (item: ItemModel) => item.id
    })
  }

  handleRefresh() {
    // 模拟网络请求
    setTimeout(() => {
      this.viewModel.dataSource.deleteAll()
      // 添加新数据
      const newData = this.generateMockData(20)
      this.viewModel.dataSource.pushDataArray(newData)
      this.controller.finishRefresh()
      this.controller.setHasmore(true)
    }, 2000)
  }

  handleLoadMore() {
    // 模拟加载更多
    setTimeout(() => {
      const moreData = this.generateMockData(10)
      this.viewModel.dataSource.pushDataArray(moreData)
      
      // 模拟没有更多数据的情况
      if (this.viewModel.dataSource.totalCount() >= 50) {
        this.controller.setHasmore(false)
      }
      
      this.controller.finishRefresh()
    }, 1500)
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Card() {
        Column() {
          Text(item.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          Text(item.content)
            .fontSize(14)
            .fontColor('#666')
            .margin({ top: 8 })
        }
        .alignItems(HorizontalAlign.Start)
        .padding(15)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(8)
    }
  }

  private generateMockData(count: number): ItemModel[] {
    // 生成模拟数据的方法
    return Array.from({ length: count }, (_, index) => ({
      id: `item_${Date.now()}_${index}`,
      title: `标题 ${index + 1}`,
      content: `这是第 ${index + 1} 项的内容描述`
    }))
  }
}
```

## 🏗️ 项目结构

```
RefreshList/
├── AppScope/                          # 应用配置
│   └── app.json5                      # 应用配置文件
├── entry/                             # 示例应用模块
│   ├── src/main/ets/
│   │   ├── entryability/              # 应用入口
│   │   ├── pages/                     # 示例页面
│   │   │   ├── Index.ets              # 主页面
│   │   │   ├── simple/                # 普通列表示例
│   │   │   │   ├── SimpleListPage.ets
│   │   │   │   └── SimpleViewModel.ets
│   │   │   ├── group/                 # 分组列表示例
│   │   │   │   ├── GroupListPage.ets
│   │   │   │   └── GroupViewModel.ets
│   │   │   ├── header/                # HeaderView 示例
│   │   │   │   └── HeaderListPage.ets
│   │   │   └── custom/                # 自定义示例
│   │   │       ├── CustomListPage.ets
│   │   │       └── CustomListModel.ets
│   │   ├── models/                    # 数据模型
│   │   │   └── ItemModel.ets
│   │   └── resources/                 # 资源文件
│   └── oh-package.json5               # 模块配置
├── refreshlist/                       # 组件库源码
│   ├── Index.ets                      # 导出文件
│   ├── BuildProfile.ets               # 构建配置
│   ├── src/main/ets/refreshlist/      # 核心组件
│   │   ├── RefreshList.ets            # 主组件
│   │   ├── RefreshController.ets      # 控制器
│   │   ├── RefreshDataSource.ets      # 数据源
│   │   ├── RefreshGroupDataSource.ets # 分组数据源
│   │   ├── RefreshGroupModel.ets      # 分组模型
│   │   ├── RefreshState.ets           # 状态定义
│   │   ├── RefreshHeader.ets          # 默认刷新头部
│   │   ├── RefreshFooter.ets          # 默认刷新底部
│   │   ├── RefreshEmptyView.ets       # 默认空数据视图
│   │   ├── RefreshLoadingView.ets     # 默认加载视图
│   │   ├── RefreshListAttrModifier.ets # 属性修饰器
│   │   └── RefreshListDirvier.ets     # 分割线接口
│   └── oh-package.json5               # 组件库配置
├── oh-package.json5                   # 项目根配置
├── LICENSE                            # 许可证
└── README.md                          # 说明文档
```



## 🔧 高级用法

### 数据源操作

```typescript
// 添加数据
dataSource.pushData(newItem)
dataSource.pushDataArray([item1, item2, item3])

// 插入数据
dataSource.insertData(0, newItem)
dataSource.insertDataArray(0, [item1, item2])

// 删除数据
dataSource.deleteIndex(0)
dataSource.deleteData(item)
dataSource.deleteAll()

// 更新数据
dataSource.repalceIndex(0, newItem)
dataSource.reloadIndex(0)
dataSource.reloadData(item)

// 移动数据
dataSource.moveDataIndex(0, 5)
```

### 控制器操作

```typescript
// 手动触发刷新
controller.onRefresh()

// 滚动到指定位置
controller.scrollToIndex(10, true, ScrollAlign.START)

// 设置是否还有加载更多
controller.setHasmore(false)

// 完成刷新
controller.finishRefresh()

// 设置是否隐藏加载更多
controller.hideLoadMore(true)
```

### 分组列表用法

```typescript
import { RefreshGroupDataSource, RefreshGroupModel } from 'refreshlist'

export class GroupViewModel {
  dataSource: RefreshGroupDataSource = new RefreshGroupDataSource()
  controller: RefreshController = new RefreshController()
  
  refresh() {
    setTimeout(() => {
      this.dataSource.deleteAll()
      
      // 方法1：手动创建分组
      const group1 = new RefreshGroupModel('分组1', new RefreshDataSource())
      group1.dataSource.pushDataArray([...items1])
      this.dataSource.pushData(group1)
      
      // 方法2：自动分组
      const allItems = [...items]
      this.dataSource.addListToGroup(allItems, (item) => item.category)
      
      this.controller.finishRefresh()
    }, 2000)
  }
}
```



##  ❓常见问题

### Q: 如何禁用下拉刷新？

```typescript
// 方法1：不传onRefresh回调
RefreshList({
  // ... 其他属性
})

// 方法2：设置pullDownRatio为0
RefreshList({
  pullDownRatio: 0,
  // ... 其他属性
})

```

### Q: 如何禁用上拉加载更多？

```typescript
// 方法1：不传onLoadMore回调
RefreshList({
  // ... 其他属性
  onRefresh: () => this.refresh(),
  // 不传onLoadMore
})

// 方法2：动态控制
this.controller.hideLoadMore(true)
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