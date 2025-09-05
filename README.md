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

### 通过本地依赖安装

在项目的 `oh-package.json5` 文件中添加依赖， 然后执行同步操作：

```json5
{
  "dependencies": {
    "@cxy/refreshlist": "^1.0.0"
  }
}
```

## 🚀 快速开始

#### 1️⃣ 创建数据模型
```typescript
// ItemModel.ets
export class ItemModel {
  id: string = ''
  title: string = ''
  
  // 基础属性
  description?: string
  category?: string
  
  // 显示属性
  avatarColor?: string
  initial?: string
  time?: string
  
  // 状态属性
  isNew?: boolean
  isOnline?: boolean
  
  // 扩展属性（根据场景使用）
  lastMessage?: string    // 聊天场景
  unreadCount?: number    // 消息数量
  price?: string          // 商品场景
  views?: number          // 浏览量
  likes?: number          // 点赞数

  constructor(id: string = '', title: string = '') {
    this.id = id
    this.title = title
  }
}
```

#### 2️⃣ 创建ViewModel
```typescript
// SimpleViewModel.ets
import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "./ItemModel"

export class SimpleViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 20

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.currentPage + 1)
  }

  private async requestData(page: number): Promise<void> {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateSimpleData(this.pageSize)

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多5页数据
      const hasMore = page < 5
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()

    }, 800)
  }

  private generateSimpleData(count: number): ItemModel[] {
    const categories = [
      '基础功能', '核心特性', '用户体验', '性能优化', '界面设计'
    ]
    const colors = [
      '#4CAF50', '#2196F3', '#FF9800', '#9C27B0', '#F44336'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const categoryIndex = globalIndex % categories.length

      const item = new ItemModel(`simple_${globalIndex}`, `${categories[categoryIndex]} ${globalIndex + 1}`)
      item.description = `展示基础的刷新和加载更多功能，简单易用的列表组件。`
      item.category = categories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = categories[categoryIndex].charAt(0)
      item.time = '刚刚'
      item.isNew = i < 3 && this.currentPage === 1 // 第一页前3个标记为新

      result.push(item)
    }
    return result
  }
}
```

#### 3️⃣ 使用组件
```typescript
// SimpleListPage.ets
import { RefreshList } from '@cxy/refreshlist'
import { SimpleViewModel } from './SimpleViewModel'
import { ItemModel } from './ItemModel'

@Component
struct SimpleListPage {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      divider: { strokeWidth: 0.5, color: '#f0f0f0' },
      keyGenerator: (item: ItemModel) => item.id
    })
    .backgroundColor('#f8f9fa')
  }

  aboutToAppear() {
    this.viewModel.refresh()
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 左侧图标
        Column() {
          Text(item.initial || item.title.charAt(0))
            .fontSize(16)
            .fontColor('#fff')
            .fontWeight(FontWeight.Medium)
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .backgroundColor(item.avatarColor || '#4CAF50')
        .justifyContent(FlexAlign.Center)

        // 内容区域
        Column() {
          Text(item.title)
            .fontSize(16)
            .fontColor('#333')
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          if (item.description) {
            Text(item.description)
              .fontSize(14)
              .fontColor('#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 底部信息
          Row() {
            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')

            if (item.isNew) {
              Text('NEW')
                .fontSize(10)
                .fontColor('#fff')
                .backgroundColor('#ff4444')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(8)
                .margin({ left: 8 })
            }
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 右侧箭头
        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(16)
          .height(16)
          .fillColor('#ccc')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
    }
    .onClick(() => {
      console.log(`点击项目: ${item.title}`)
    })
  }
}
```

🎉 **就是这么简单！** 三步即可拥有一个功能完整的刷新列表。

## 📚 API 文档

### RefreshList 组件属性

#### 必需属性

| 属性         | 类型                                          | 说明                |
|------------|---------------------------------------------|-------------------|
| dataSource | RefreshDataSource \| RefreshGroupDataSource | 数据源，管理列表数据        |
| controller | RefreshController                           | 控制器，用于控制刷新状态和列表操作 |

#### 布局属性

| 属性                  | 类型                                      | 默认值    | 说明                           |
|---------------------|-----------------------------------------|--------|------------------------------|
| itemLayout          | (item: Object, index: number) => void  | -      | 列表项布局，必需属性                   |
| customLayout        | () => void                              | -      | 自定义布局，完全自定义LazyForEach部分     |
| headerLayout        | () => void                              | -      | 列表头部布局，类似iOS的tableHeaderView |
| loadingLayout       | () => void                              | 默认加载视图 | 加载中状态的布局                     |
| emptyLayout         | () => void                              | 默认空视图  | 空数据状态的布局                     |
| refreshHeaderLayout | () => void                              | 默认刷新头部 | 自定义下拉刷新头部布局                  |
| refreshFooterLayout | () => void                              | 默认刷新底部 | 自定义上拉加载底部布局                  |

#### 数据状态属性

| 属性                | 类型                | 默认值 | 说明                    |
|-------------------|-------------------|-----|---------------------|
| refreshHeaderData | RefreshHeaderData | -   | 下拉刷新头部数据，用于自定义刷新头部状态 |
| refreshFooterData | RefreshFooterData | -   | 上拉加载底部数据，用于自定义加载底部状态 |
| showLoading       | boolean           | true | 是否显示加载状态            |
| showEmpty         | boolean           | true | 是否显示空数据状态           |

#### 列表配置属性

| 属性                             | 类型                      | 默认值                   | 说明                              |
|--------------------------------|-------------------------|----------------------|---------------------------------|
| cachedCount                    | number                  | 4                    | 缓存的列表项数量，用于性能优化，建议使用列表能显示列表项的一半 |
| itemSpace                      | number                  | 0                    | 列表项间距                           |
| pullDownRatio                  | number                  | 0.62                 | 设置下拉跟手系数，禁止下拉设置0                |
| divider                        | RefreshListDivider      | null                 | 分割线样式                           |
| lanes                          | number                  | 1                    | 设置List组件的布局列数或行数（网格布局）          |
| gutter                         | Dimension               | 0                    | 列间距（网格布局时使用）                    |
| maintainVisibleContentPosition | boolean                 | false                | 插入或删除数据时是否保持可见内容位置不变            |
| edfeEffect                     | EdgeEffect              | EdgeEffect.Spring    | List的EdgeEffect效果               |
| listAttrModifier               | RefreshListAttrModifier | -                    | 用于自定义更多List属性                   |
| barState                       | BarState                | BarState.On          | 滚动条状态                           |

#### 回调函数

| 属性            | 类型                                        | 说明           |
|---------------|-------------------------------------------|--------------|
| onRefresh     | () => void                                | 下拉刷新时的回调函数   |
| onLoadMore    | () => void                                | 上拉加载更多时的回调函数 |
| keyGenerator  | (item: Object, index: number) => string  | 列表项唯一标识生成器   |
| onDidScroll   | (scrollOffset: number, scrollState: ScrollState) => void | 滚动时的回调函数     |
| onReachEnd    | () => void                                | 滚动到底部时的回调函数  |
| onScrollIndex | (start: number, end: number) => void      | 滚动到索引时的回调函数  |

### RefreshController 控制器

RefreshController 提供了控制刷新列表的各种方法：

#### 属性

| 属性       | 类型           | 说明      |
|----------|--------------|---------|
| scroller | ListScroller | 列表滚动控制器，可用于获取滚动位置等信息 |

#### 方法

| 方法            | 参数                                                                                     | 返回值  | 说明                |
|---------------|----------------------------------------------------------------------------------------|------|-------------------|
| finishRefresh | ()                                                                                     | void | 结束刷新状态，必须在刷新完成后调用 |
| setHasmore    | (hasmore: boolean)                                                                     | void | 设置是否还有更多数据可加载     |
| hideLoadMore  | (hide: boolean)                                                                        | void | 隐藏或显示加载更多组件       |
| onRefresh     | ()                                                                                     | void | 手动触发下拉刷新          |
| scrollToIndex | (index: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) | void | 滚动到指定索引位置         |

#### 使用示例

```typescript
export class SimpleViewModel {
  controller: RefreshController = new RefreshController()

  refresh(): void {
    // 模拟网络请求
    setTimeout(() => {
      // 处理数据...
      
      // 必须调用finishRefresh结束刷新状态
      this.controller.finishRefresh()
      
      // 设置是否还有更多数据
      this.controller.setHasmore(hasMore)
    }, 1000)
  }

  // 手动触发刷新
  manualRefresh(): void {
    this.controller.onRefresh()
  }

  // 滚动到顶部
  scrollToTop(): void {
    this.controller.scrollToIndex(0, true)
  }

  // 获取当前滚动位置
  getCurrentOffset(): number {
    return this.controller.scroller.currentOffset().yOffset
  }
}
```

### RefreshDataSource 数据源

RefreshDataSource 是管理列表数据的核心类，实现了 IDataSource 接口：

#### 基础方法

| 方法             | 参数              | 返回值                 | 说明                      |
|----------------|-----------------|---------------------|-------------------------|
| isEmpty        | ()              | boolean             | 判断数据源是否为空               |
| totalCount     | ()              | number              | 获取数据总数 (分组时，为分组数量)      |
| totalItemCount | ()              | number              | 获取数据项总数（分组时，为分组下item总数） |
| getData        | (index: number) | Object \| undefined | 获取指定索引的数据               |
| getLastData    | ()              | Object \| undefined | 获取最后一项数据                |
| getDataAll     | ()              | Object[]            | 获取所有数据的副本               |

#### 数据操作方法

| 方法               | 参数                                          | 返回值  | 说明               |
|------------------|---------------------------------------------|------|------------------|
| insertData       | (index: number, data: Object)               | void | 在指定位置插入单个数据      |
| insertDataArray  | (index: number, arr: Object[])              | void | 在指定位置插入数据数组      |
| pushData         | (data: Object)                              | void | 在末尾添加单个数据        |
| pushDataArray    | (arr: Object[])                             | void | 在末尾添加数据数组        |
| deleteIndex      | (index: number)                             | void | 删除指定索引的数据        |
| deleteData       | (data: Object)                              | void | 删除指定数据对象         |
| deleteAll        | ()                                          | void | 删除所有数据           |
| deleteIndexCount | (index: number, count: number)              | void | 从指定索引开始删除指定数量的数据 |
| repalceIndex     | (index: number, data: Object, key?: string) | void | 替换指定索引的数据        |
| reloadIndex      | (index: number, key?: string)               | void | 重新加载指定索引的数据      |
| reloadData       | (data: Object, key?: string)                | void | 重新加载指定数据对象       |
| reloadDataAll    | ()                                          | void | 重新加载所有数据         |
| moveDataIndex    | (from: number, to: number)                  | void | 移动数据从一个位置到另一个位置  |

#### 监听器方法

| 方法                           | 参数                             | 返回值  | 说明          |
|------------------------------|--------------------------------|------|-------------|
| registerDataChangeListener   | (listener: DataChangeListener) | void | 注册数据变化监听器   |
| unregisterDataChangeListener | (listener: DataChangeListener) | void | 取消注册数据变化监听器 |

#### 回调属性

| 属性                | 类型                      | 说明         |
|-------------------|-------------------------|------------|
| onDataCountChange | (count: number) => void | 数据数量变化时的回调 |

### RefreshGroupDataSource 分组数据源

RefreshGroupDataSource 继承自 RefreshDataSource，专门用于管理分组列表数据：

#### 重写方法

| 方法              | 参数 | 返回值      | 说明            |
|-----------------|----|----------|---------------|
| isEmpty         | () | boolean  | 判断分组数据源是否为空   |
| totalItemCount  | () | number   | 计算所有分组中的数据项总数 |
| getGroupDataAll | () | Object[] | 获取所有分组中的数据项   |

#### 分组特有方法

| 方法             | 参数                                                  | 返回值  | 说明           |
|----------------|-----------------------------------------------------|------|--------------|
| addListToGroup | (list: Object[], getTitle: (e: Object) => string) | void | 将数据列表按标题分组添加 |

#### 使用示例

```typescript
// 基础数据源使用
export class SimpleViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()

  refresh(): void {
    // 清空现有数据
    this.dataSource.deleteAll()
    
    // 添加新数据
    const newData = this.generateData()
    this.dataSource.pushDataArray(newData)
  }

  addItem(item: ItemModel): void {
    this.dataSource.pushData(item)
  }

  removeItem(item: ItemModel): void {
    this.dataSource.deleteData(item)
  }

  updateItem(index: number, newItem: ItemModel): void {
    this.dataSource.repalceIndex(index, newItem)
  }
}

// 分组数据源使用
export class GroupViewModel {
  dataSource: RefreshGroupDataSource = new RefreshGroupDataSource()

  refresh(): void {
    this.dataSource.deleteAll()
    
    const allItems = this.generateData()
    // 按category字段自动分组
    this.dataSource.addListToGroup(allItems, (item) => item.category)
  }
}
```

### RefreshGroupModel 分组模型

分组数据的模型类：

#### 属性

| 属性         | 类型                | 说明      |
|------------|-------------------|---------|
| title      | string            | 分组标题    |
| dataSource | RefreshDataSource | 分组内的数据源 |
| data       | Object            | 可选的附加数据 |

#### 构造函数

```typescript
constructor(title: string, dataSource: RefreshDataSource)
```

### RefreshHeaderData 刷新头部数据

下拉刷新头部的状态数据：

| 属性            | 类型                              | 默认值                    | 说明                                        |
|---------------|----------------------------------|-------------------------|-------------------------------------------|
| state         | RefreshStatus                    | RefreshStatus.Inactive  | 刷新状态（Inactive、Drag、OverDrag、Refresh、Done） |
| offset        | number                           | 0                       | 下拉偏移量                                     |
| dragText      | ResourceStr                      | '下拉刷新'                 | 下拉时显示的文本                                  |
| overDragText  | ResourceStr                      | '释放刷新'                 | 超过阈值时显示的文本                                |
| refreshText   | ResourceStr                      | '刷新中...'               | 刷新中显示的文本                                  |
| doneText      | ResourceStr                      | '刷新完成'                 | 刷新完成显示的文本                                 |
| textColor     | ResourceColor                    | '#bbb'                  | 文本颜色                                      |
| font          | Font                             | { size: 13 }            | 文本字体                                      |
| loadingColor  | ResourceColor \| LinearGradient  | LinearGradient          | loading 颜色                                |
| loadingSize   | SizeOptions                      | { width: 20, height: 20 } | loading 大小                                |

#### 方法

| 方法      | 参数 | 返回值        | 说明            |
|---------|----|-----------|--------------|
| getText | () | ResourceStr | 根据当前状态返回对应的文本 |

### RefreshFooterData 刷新底部数据

上拉加载更多底部的状态数据：

| 属性          | 类型                 | 默认值                     | 说明           |
|-------------|--------------------|-------------------------|--------------|
| isShow      | boolean            | true                    | 是否显示底部组件     |
| state       | RefreshFooterState | RefreshFooterState.None | 加载状态         |
| noneText    | ResourceStr        | '上拉加载更多'               | 默认状态显示的文本    |
| loadingText | ResourceStr        | '加载中...'                | 加载中显示的文本     |
| noMoreText  | ResourceStr        | '没有更多了'                | 没有更多数据时显示的文本 |
| textColor   | ResourceColor      | '#bbb'                  | 文本颜色         |
| font        | Font               | { size: 13 }            | 文本字体         |
| loadingColor| ResourceColor      | '#bbb'                  | loading 颜色    |
| loadingSize | SizeOptions        | { width: 20, height: 20 } | loading 大小    |

#### 方法

| 方法      | 参数 | 返回值        | 说明            |
|---------|----|-----------|--------------|
| getText | () | ResourceStr | 根据当前状态返回对应的文本 |

### RefreshFooterState 枚举

加载更多的状态枚举：

| 值       | 数值 | 说明     |
|---------|----|--------|
| None    | 0  | 默认状态   |
| Loading | 1  | 正在加载中  |
| NoMore  | 2  | 没有更多数据 |
| NoMore  | 2  | 没有更多数据 |

### RefreshGlobalConfig 全局配置

全局配置类，用于设置所有RefreshList组件的默认样式和行为：

#### 静态属性

| 属性                  | 类型                                    | 默认值                    | 说明           |
|---------------------|---------------------------------------|-------------------------|--------------|
| headerBuilder       | WrappedBuilder<[IRefreshHeaderData]>  | -                       | 全局自定义刷新头部构建器 |
| footerBuilder       | WrappedBuilder<[IRefreshFooterData]>  | -                       | 全局自定义刷新底部构建器 |
| loadingBuilder      | WrappedBuilder<[]>                    | -                       | 全局自定义加载构建器   |
| emptyBuilder        | WrappedBuilder<[]>                    | -                       | 全局自定义空状态构建器  |
| headerInactiveText  | ResourceStr                           | '刷新'                    | 头部非活动状态文本    |
| headerDragText      | ResourceStr                           | '下拉刷新'                 | 头部下拉状态文本     |
| headerOverDragText  | ResourceStr                           | '释放刷新'                 | 头部超过阈值状态文本   |
| headerRefreshText   | ResourceStr                           | '刷新中...'               | 头部刷新中状态文本    |
| headerDoneText      | ResourceStr                           | '刷新完成'                 | 头部刷新完成状态文本   |
| footerNoneText      | ResourceStr                           | '上拉加载更多'               | 底部默认状态文本     |
| footerLoadingText   | ResourceStr                           | '加载中...'               | 底部加载中状态文本    |
| footerNoMoreText    | ResourceStr                           | '没有更多了'                | 底部没有更多数据状态文本 |
| headerTextColor     | ResourceColor                         | '#bbb'                  | 头部文本颜色       |
| footerTextColor     | ResourceColor                         | '#bbb'                  | 底部文本颜色       |
| headerTextFont      | Font                                  | { size: 13 }            | 头部文本字体       |
| footerTextFont      | Font                                  | { size: 13 }            | 底部文本字体       |
| headerLoadingColor  | ResourceColor \| LinearGradient       | LinearGradient          | 头部loading颜色   |
| footerLoadingColor  | ResourceColor                         | '#bbb'                  | 底部loading颜色   |
| headerLoadingSize   | SizeOptions                           | { width: 20, height: 20 } | 头部loading大小   |
| footerLoadingSize   | SizeOptions                           | { width: 20, height: 20 } | 底部loading大小   |

#### 使用示例

```typescript
import { RefreshGlobalConfig, IRefreshHeaderData, RefreshStatus } from '@cxy/refreshlist'

// 全局自定义刷新头部
@Builder
function globalHeaderBuilder(item: IRefreshHeaderData) {
  GlobalHeader({ data: item.data })
}

// 配置全局设置
function setupGlobalConfig() {
  RefreshGlobalConfig.headerBuilder = wrapBuilder(globalHeaderBuilder)
  RefreshGlobalConfig.headerDragText = '下拉刷新数据'
  RefreshGlobalConfig.headerOverDragText = '释放立即刷新'
  RefreshGlobalConfig.headerRefreshText = '正在刷新数据...'
  RefreshGlobalConfig.headerDoneText = '刷新成功'
  RefreshGlobalConfig.footerNoneText = '上拉加载更多'
  RefreshGlobalConfig.footerLoadingText = '数据加载中...'
  RefreshGlobalConfig.footerNoMoreText = '亲，没有更多了'
  RefreshGlobalConfig.headerTextColor = '#333'
  RefreshGlobalConfig.footerTextColor = '#666'
}

// 在应用启动时调用
setupGlobalConfig()
```

### IRefreshHeaderData 接口

刷新头部数据接口：

| 属性   | 类型                | 说明       |
|------|-------------------|----------|
| data | RefreshHeaderData | 刷新头部状态数据 |

### IRefreshFooterData 接口

刷新底部数据接口：

| 属性   | 类型                | 说明       |
|------|-------------------|----------|
| data | RefreshFooterData | 刷新底部状态数据 |

### RefreshListDivider 分割线接口

自定义分割线样式的接口：

| 属性          | 类型            | 必需 | 说明    |
|-------------|---------------|----|-------|
| strokeWidth | Length        | 是  | 分割线宽度 |
| color       | ResourceColor | 否  | 分割线颜色 |
| startMargin | Length        | 否  | 起始边距  |
| endMargin   | Length        | 否  | 结束边距  |

### RefreshListAttrModifier 属性修饰器

用于自定义更多List属性的修饰器类：

```typescript
export class RefreshListAttrModifier implements AttributeModifier<ListAttribute> {
  applyNormalAttribute(instance: ListAttribute): void {
    // 在这里可以自定义更多List属性
    // 例如：背景色、边框、阴影等
  }
}

// 使用示例
class CustomAttrModifier extends RefreshListAttrModifier {
  applyNormalAttribute(instance: ListAttribute): void {
    instance.backgroundColor('#f5f5f5')
    instance.borderRadius(10)
    instance.padding(10)
  }
}
```

## 💡 使用示例精选

基于项目中10个完整示例的核心代码，涵盖各种实际使用场景：

### 1. 基础列表 - 最简单的使用方式
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
      divider: { strokeWidth: 0.5, color: '#f0f0f0' },
      keyGenerator: (item: ItemModel) => item.id
    })
    .backgroundColor('#f8f9fa')
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 左侧图标
        Column() {
          Text(item.initial || item.title.charAt(0))
            .fontSize(16)
            .fontColor('#fff')
            .fontWeight(FontWeight.Medium)
        }
        .width(40).height(40)
        .borderRadius(20)
        .backgroundColor(item.avatarColor || '#4CAF50')
        .justifyContent(FlexAlign.Center)

        // 内容区域
        Column() {
          Text(item.title)
            .fontSize(16)
            .fontColor('#333')
            .fontWeight(FontWeight.Medium)
          
          if (item.description) {
            Text(item.description)
              .fontSize(14)
              .fontColor('#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 底部信息
          Row() {
            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')

            if (item.isNew) {
              Text('NEW')
                .fontSize(10)
                .fontColor('#fff')
                .backgroundColor('#ff4444')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(8)
                .margin({ left: 8 })
            }
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 右侧箭头
        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(16)
          .height(16)
          .fillColor('#ccc')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
    }
    .onClick(() => {
      console.log(`点击项目: ${item.title}`)
    })
  }
}
```

### 2. 分组列表 - 自动分组功能

```typescript
// ViewModel中自动分组
refresh() {
  setTimeout(() => {
    this.dataSource.deleteAll()
    const allItems = this.generateData()
    // 按category字段自动分组
    this.dataSource.addListToGroup(allItems, (item) => item.category)
    this.controller.finishRefresh()
  }, 800)
}

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
      divider: { strokeWidth: 0, color: 'transparent' },
      keyGenerator: (group: RefreshGroupModel) => group.title
    })
    .backgroundColor('#f5f5f5')
  }

  @Builder
  groupLayout(group: RefreshGroupModel): void {
    ListItemGroup({
      header: this.sectionHeader(group),
      space: 8
    }) {
      LazyForEach(group.dataSource, (item: ItemModel, index: number) => {
        ListItem() {
          this.groupItemLayout(item, index)
        }
      }, (item: ItemModel) => item.id)
    }
    .margin({ bottom: 16 })
  }

  @Builder
  sectionHeader(group: RefreshGroupModel): void {
    Row() {
      // 分组图标
      Column() {
        Text(group.title.charAt(0))
          .fontSize(14)
          .fontColor('#fff')
          .fontWeight(FontWeight.Bold)
      }
      .width(32).height(32)
      .borderRadius(16)
      .backgroundColor('#2196F3')
      .justifyContent(FlexAlign.Center)

      // 分组标题和统计
      Column() {
        Text(group.title)
          .fontSize(16)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)

        Text(`${group.dataSource.totalCount()} 项`)
          .fontSize(12)
          .fontColor('#666')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fff')
    .borderRadius({ topLeft: 12, topRight: 12 })
  }

  @Builder
  groupItemLayout(item: ItemModel, index: number): void {
    Row() {
      Text(`${index + 1}`)
        .fontSize(12)
        .fontColor('#999')
        .width(24)
        .textAlign(TextAlign.Center)

      Column() {
        Text(item.title)
          .fontSize(15)
          .fontColor('#333')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        if (item.description) {
          Text(item.description)
            .fontSize(13)
            .fontColor('#666')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fff')
  }
}
```

### 3. 网格布局 - 商品展示
```typescript
@Component
struct GridList {
  @State viewModel: GridViewModel = new GridViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.gridItemLayout(item as ItemModel),

      // 网格布局配置
      lanes: 2,        // 两列布局
      gutter: 10,      // 列间距
      itemSpace: 10,   // 行间距

      keyGenerator: (item: ItemModel) => item.id
    })
  }

  @Builder
  gridItemLayout(item: ItemModel): void {
    ListItem() {
      Column() {
        // 商品图片
        Image(item.image || $r('app.media.app_icon'))
          .width('100%')
          .height(120)
          .borderRadius({ topLeft: 8, topRight: 8 })
          .objectFit(ImageFit.Cover)

        // 商品信息
        Column() {
          Text(item.title)
            .fontSize(14)
            .fontColor('#333')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(`¥${item.price || '99.00'}`)
            .fontSize(16)
            .fontColor('#ff4444')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 8 })

          Row() {
            Text(`销量${item.sales || '999+'}`)
              .fontSize(12)
              .fontColor('#999')

            // 星级评价
            Row() {
              ForEach([1, 2, 3, 4, 5], (star: number) => {
                Text('⭐')
                  .fontSize(12)
                  .fontColor(star <= (item.rating || 4) ? '#ffcc00' : '#ddd')
              })
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 5 })
        }
        .padding(10)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(8)
      .shadow({
        radius: 4,
        color: '#1f000000',
        offsetX: 0,
        offsetY: 2
      })
    }
  }
}
```

### 4. 聊天列表 - 仿微信样式
```typescript
@Component
struct ChatList {
  @State viewModel: ChatViewModel = new ChatViewModel()

  build() {
    Column() {
      // 顶部搜索栏
      this.searchHeader()

      // 聊天列表
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        itemLayout: (item: Object, index: number) => this.chatItemLayout(item as ItemModel),
        divider: {
          strokeWidth: 0.5,
          color: '#f0f0f0',
          startMargin: 70,
          endMargin: 0
        },
        keyGenerator: (item: ItemModel) => item.id
      })
      .layoutWeight(1)
    }
    .backgroundColor('#f8f8f8')
  }

  @Builder
  searchHeader(): void {
    Row() {
      Row() {
        Image($r('sys.media.ohos_ic_public_search_filled'))
          .width(16).height(16).fillColor('#999')

        Text('搜索聊天记录')
          .fontSize(14).fontColor('#999').margin({ left: 8 })
      }
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .backgroundColor('#f0f0f0')
      .borderRadius(20)
      .layoutWeight(1)

      Image($r('sys.media.ohos_ic_public_add'))
        .width(24).height(24).fillColor('#007AFF').margin({ left: 12 })
    }
    .width('100%').padding(15).backgroundColor(Color.White)
  }

  @Builder
  chatItemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 头像
        Stack() {
          Image(item.avatar)
            .alt($r('app.media.foreground'))
            .borderRadius(25)
            .width(50).height(50)
            .objectFit(ImageFit.Cover)

          // 在线状态指示器
          if (item.isOnline) {
            Circle({ width: 12, height: 12 })
              .fill('#00C851')
              .stroke(Color.White)
              .strokeWidth(2)
          }
        }
        .alignContent(Alignment.BottomEnd)

        // 聊天信息
        Column() {
          Row() {
            Text(item.name || item.title)
              .fontSize(16)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Row() {
            Text(item.lastMessage || '暂无消息')
              .fontSize(14)
              .fontColor('#666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            // 未读消息数
            if (item.unreadCount && item.unreadCount > 0) {
              Text(item.unreadCount > 99 ? '99+' : item.unreadCount.toString())
                .fontSize(12)
                .fontColor(Color.White)
                .backgroundColor('#ff4444')
                .borderRadius(10)
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .textAlign(TextAlign.Center)
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 12, bottom: 12 })
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Color.White)
    .swipeAction({
      end: () => this.slideRightMenuLayout(item)
    })
  }

  @Builder
  slideRightMenuLayout(item: ItemModel): void {
    Row() {
      Text('删除')
        .height('100%')
        .fontColor('#fff')
        .backgroundColor(Color.Red)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .width(80)
        .onClick(() => {
          this.viewModel.dataSource.deleteData(item)
        })
    }
    .layoutWeight(1)
  }
}
```

### 5. 带 HeaderView 的列表
```typescript
@Component
struct HeaderList {
  @State viewModel: HeaderViewModel = new HeaderViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      
      // 自定义头部布局
      headerLayout: () => this.headerLayout(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      keyGenerator: (item: ItemModel) => item.id
    })
    .backgroundColor('#f8f9fa')
  }

  @Builder
  headerLayout(): void {
    Column() {
      // 顶部横幅
      Stack() {
        // 背景渐变
        Column()
          .width('100%')
          .height('100%')
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [['#667eea', 0.0], ['#764ba2', 1.0]]
          })

        // 内容区域
        Column() {
          Text('RefreshList 组件')
            .fontSize(24)
            .fontColor('#fff')
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Text('简单易用的下拉刷新和上拉加载组件')
            .fontSize(14)
            .fontColor('#ffffff80')
            .margin({ bottom: 20 })

          // 统计信息
          Row() {
            this.statItem({ title: '总数据', count: `${this.viewModel.getTotalCount()}` })
            this.statItem({ title: '已加载', count: `${this.viewModel.totalCount}` })
            this.statItem({ title: '页数', count: `${this.viewModel.currentPage}` })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
        }
        .padding(20)
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(180)

      // 功能卡片区域
      Row() {
        this.featureCard('🔄', '下拉刷新', '支持自定义刷新动画')
        this.featureCard('🚀', '上拉加载', '加载更多数据')
        this.featureCard('⚒️', '易用', '集成Loading和空页面')
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .backgroundColor('#fff')
  }

  @Builder
  statItem(item: { title: string, count: string }): void {
    Column() {
      Text(item.count)
        .fontSize(18)
        .fontColor('#fff')
        .fontWeight(FontWeight.Bold)

      Text(item.title)
        .fontSize(14)
        .fontColor('#ffffff80')
        .margin({ top: 4 })
    }
  }

  @Builder
  featureCard(icon: string, title: string, desc: string): void {
    Column() {
      Text(icon)
        .fontSize(24)
        .margin({ bottom: 8 })

      Text(title)
        .fontSize(14)
        .fontColor('#333')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 4 })

      Text(desc)
        .fontSize(12)
        .fontColor('#666')
        .textAlign(TextAlign.Center)
        .maxLines(2)
    }
    .width('30%')
    .padding(12)
    .backgroundColor('#fff')
    .borderRadius(8)
    .shadow({
      radius: 4,
      color: '#1a000000',
      offsetX: 0,
      offsetY: 2
    })
  }
}
```

### 6. 全局配置示例
```typescript
import { RefreshGlobalConfig, IRefreshHeaderData, RefreshStatus } from '@cxy/refreshlist'

@Builder
function globalHeaderBuilder(item: IRefreshHeaderData) {
  GlobalHeader({ data: item.data })
}

@Component
struct GlobalHeader {
  @ObjectLink data: RefreshHeaderData

  build() {
    Column({ space: 5 }) {
      if (this.data.state === RefreshStatus.Refresh) {
        LoadingProgress()
          .width(this.data.loadingSize.width)
          .height(this.data.loadingSize.height)
          .color(this.data.loadingColor)
      } else {
        Image($r('app.media.custom_loading'))
          .height(25)
      }

      Text(this.data.getText())
        .fontColor(this.data.textColor)
        .fontSize(this.data.font.size)
    }
    .padding(10)
  }
}

// 全局配置
function setupGlobalConfig() {
  RefreshGlobalConfig.headerBuilder = wrapBuilder(globalHeaderBuilder)
  RefreshGlobalConfig.headerDragText = '下拉刷新数据'
  RefreshGlobalConfig.headerOverDragText = '释放立即刷新'
  RefreshGlobalConfig.headerRefreshText = '正在刷新数据...'
  RefreshGlobalConfig.headerDoneText = '刷新成功'
  RefreshGlobalConfig.footerNoneText = '上拉加载更多'
  RefreshGlobalConfig.footerLoadingText = '数据加载中...'
  RefreshGlobalConfig.footerNoMoreText = '亲，没有更多了'
  RefreshGlobalConfig.headerTextColor = '#333'
  RefreshGlobalConfig.footerTextColor = '#666'
}

// 在应用启动时调用
setupGlobalConfig()

@Component
struct GlobalPage {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    RefreshList({
      dataSource: this.viewModel.dataSource,
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.refresh(),
      onLoadMore: () => this.viewModel.loadMore(),
      itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
      keyGenerator: (item: ItemModel) => item.id
    })
    // 全局配置会自动应用到所有RefreshList组件
  }
}
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
import { RefreshList, RefreshHeaderData, RefreshFooterData, RefreshFooterState, RefreshStatus } from '@cxy/refreshlist'

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
        .width(this.refreshHeaderData.loadingSize.width)
        .height(this.refreshHeaderData.loadingSize.height)
        .color(this.refreshHeaderData.loadingColor)
        .visibility(this.refreshHeaderData.state === RefreshStatus.Refresh ? Visibility.Visible : Visibility.Hidden)
      
      Text(this.refreshHeaderData.getText())
        .fontSize(this.refreshHeaderData.font.size)
        .fontColor(this.refreshHeaderData.textColor)
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
            .width(this.refreshFooterData.loadingSize.width)
            .height(this.refreshFooterData.loadingSize.height)
            .color(this.refreshFooterData.loadingColor)
          Text(this.refreshFooterData.loadingText)
            .fontSize(this.refreshFooterData.font.size)
            .fontColor(this.refreshFooterData.textColor)
            .margin({ left: 8 })
        } else {
          Text(this.refreshFooterData.getText())
            .fontSize(this.refreshFooterData.font.size)
            .fontColor(this.refreshFooterData.textColor)
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
import { RefreshGroupDataSource, RefreshGroupModel } from '@cxy/refreshlist'

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

## ❓常见问题

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
// 方法1：不传onLoadMore回调（推荐）
RefreshList({
  onRefresh: () => this.refresh(),
  // 不传onLoadMore即可禁用上拉加载
})

// 方法2：动态控制显示/隐藏
this.controller.hideLoadMore(true)  // 隐藏加载更多
this.controller.setHasmore(false)   // 设置没有更多数据
```

### Q: 如何实现无限滚动（不显示加载更多提示）？
```typescript
RefreshList({
  onLoadMore: () => this.loadMore(),
  refreshFooterLayout: () => {}, // 传入空布局隐藏底部提示
})
```

### Q: 如何监听列表滚动事件？
```typescript
RefreshList({
  onDidScroll: (scrollOffset: number, scrollState: ScrollState) => {
    console.log(`滚动偏移: ${scrollOffset}`)
    // 可以根据滚动位置实现悬浮按钮显示/隐藏等功能
  },
  onScrollIndex: (start: number, end: number) => {
    console.log(`当前可见范围: ${start} - ${end}`)
    // 可以用于埋点统计、预加载等
  }
})
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

8、[RefreshList](https://github.com/iHongRen/RefreshList) - 功能完善的上拉下拉加载组件，支持各种自定义。



如果项目对你有帮助，欢迎持续关注和 [🌟Star](https://github.com/iHongRen/RefreshList) ，[💖赞助](https://ihongren.github.io/donate.html)

