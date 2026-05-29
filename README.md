# RefreshList

[![License](https://img.shields.io/badge/license-Apache2.0-blue.svg)](LICENSE)
[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-orange.svg)](https://developer.harmonyos.com/)
[![Version](https://img.shields.io/github/v/release/iHongRen/RefreshList)](https://github.com/iHongRen/RefreshList/releases/latest)

鸿蒙HarmonyOS NEXT 简单易用的上拉下拉刷新组件，支持自定义样式和多种使用场景，兼容API 15+。

## 特性

- 支持下拉刷新和上拉加载更多
- 支持自定义刷新头部和底部组件
- 支持自定义加载中和空页面组件
- 支持自定义 HeaderView 组件
- 支持分组列表
- 支持全局自定义各种组件
- 完善的 demo 示例

## 安装

### 通过 ohpm 安装

```bash
ohpm install @cxy/refreshlist
```

### 通过依赖安装

在项目的 `oh-package.json5` 文件中添加依赖， 然后执行同步操作：

```json5
{
  "dependencies": {
    "@cxy/refreshlist": "^1.1.0"
  }
}
```

## Demo - [前往查看示例代码](https://github.com/iHongRen/RefreshList)

|                                                              |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://i.mji.rip/2025/09/08/fb40bffdddf82a6c1ca8b773ff1c97bf.jpeg" alt="demo.jpeg" width=250><br>**Demo 页面**<br> | <img src="https://i.mji.rip/2025/09/08/1bc7f774ee99a9dfe13a50e5ad5b108b.gif" alt="simple.gif" width=250><br>**简单示例**<br> | <img src="https://i.mji.rip/2025/09/08/6de85128e07c7fb5add707f2b0e0a915.gif" alt="group.gif" width=250><br>**分组示例**<br> |
| <img src="https://i.mji.rip/2025/09/08/84ab86ab3b9a2e20cb73b078a340c5b8.gif" alt="headerview.gif" width=250><br>**自定义HeaderView示例**<br> | <img src="https://i.mji.rip/2025/09/08/8fae5be2ad8de2a9514a2d9ca4dd7207.gif" alt="custom.gif" width=250><br>**各种自定义示例**<br> | <img src="https://i.mji.rip/2025/09/08/138fd06fc7a34b9d2cdc9010650e741e.gif" alt="chat.gif" width=250><br>**聊天示例**<br> |
| <img src="https://i.mji.rip/2025/09/08/b47a0e77b160652cce6591bfe7633767.gif" alt="dynamic.gif" width=250><br>**动态刷新示例**<br> | <img src="https://i.mji.rip/2025/09/08/e2c0bfe4d0fe42acd8d67b6c1de0b97b.gif" alt="infinite.gif" width=250><br>**无限加载示例**<br> | <img src="https://i.mji.rip/2025/09/08/e8f817db4bb5a2317c44b616f85d66da.gif" alt="search.gif" width=250><br>**搜索示例**<br> |
| <img src="https://i.mji.rip/2025/09/08/bafce049adf9471e497240cfb9d83f38.gif" alt="grid.gif" width=250>**<br>网格示例**<br> | <img src="https://i.mji.rip/2025/09/08/57101cd918ac3a3b8fd4b427d440c3fa.gif" alt="advanced.gif" width=250><br>**高级使用示例**<br> | <img src="https://i.mji.rip/2025/09/08/4adf3411de978da386d470a72f6c2492.gif" alt="global.gif" width=250><br>**全局配置示例**<br> |

## 快速开始

```typescript
import { RefreshController, RefreshDataSource, RefreshList } from "@cxy/refreshlist"

// 1. 创建数据模型
class ItemModel {
  id: string = ''
  title: string = ''

  constructor(id: string = '', title: string = '') {
    this.id = id
    this.title = title
  }
}

// 2. 创建ViewModel
class SimpleViewModel {
  @Track dataSource: RefreshDataSource = new RefreshDataSource()
  @Track controller: RefreshController = new RefreshController()
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
    }, 500)
  }

  private generateSimpleData(count: number): ItemModel[] {
    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const item = new ItemModel(`simple_${globalIndex}`, `Title - ${globalIndex + 1}`)
      result.push(item)
    }
    return result
  }
}


// 3. 使用组件
@Entry
@Component
struct Index {
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  aboutToAppear() {
    this.viewModel.refresh()
  }

  build() {
    Column() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
        divider: { strokeWidth: 0.5, color: '#f0f0f0' },
        keyGenerator: (item: ItemModel) => item.id
      })
    }
  }

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        Text(item.title)
          .fontSize(16)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)

        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(16)
          .height(16)
          .fillColor('#ccc')
      }
      .width('100%')
        .padding(16)
        .backgroundColor('#fff')
    }
    .onClick(()=> {
      console.log(`点击项目: ${ item.title}`)
    })
  }
}

```

**就是这么简单！** 三步即可拥有一个功能完整的刷新列表。

<details>
<summary><strong>RefreshList 组件属性</strong></summary>

#### 必需属性

| 属性       | 类型                                        | 说明                               |
| ---------- | ------------------------------------------- | ---------------------------------- |
| dataSource | RefreshDataSource \| RefreshGroupDataSource | 数据源，管理列表数据               |
| controller | RefreshController                           | 控制器，用于控制刷新状态和列表操作 |

#### 布局属性

| 属性                | 类型                                  | 默认值       | 说明                                   |
| ------------------- | ------------------------------------- | ------------ | -------------------------------------- |
| itemLayout          | (item: Object, index: number) => void | -            | 列表项布局                             |
| customLayout        | () => void                            | -            | 自定义布局，完全自定义LazyForEach部分  |
| headerLayout        | () => void                            | -            | 列表头部布局，类似iOS的tableHeaderView |
| loadingLayout       | () => void                            | 默认加载视图 | 加载中状态的布局                       |
| emptyLayout         | () => void                            | 默认空视图   | 空数据状态的布局                       |
| refreshHeaderLayout | () => void                            | 默认刷新头部 | 自定义下拉刷新头部布局                 |
| refreshFooterLayout | () => void                            | 默认刷新底部 | 自定义上拉加载底部布局                 |

#### 数据状态属性

| 属性              | 类型              | 默认值 | 说明                                     |
| ----------------- | ----------------- | ------ | ---------------------------------------- |
| refreshHeaderData | RefreshHeaderData | -      | 下拉刷新头部数据，用于自定义刷新头部状态 |
| refreshFooterData | RefreshFooterData | -      | 上拉加载底部数据，用于自定义加载底部状态 |
| showLoading       | boolean           | true   | 是否显示加载状态                         |
| showEmpty         | boolean           | true   | 是否显示空数据状态                       |

#### 列表配置属性

| 属性                           | 类型                      | 默认值                       | 说明                                                         |
| ------------------------------ | ------------------------- | ---------------------------- | ------------------------------------------------------------ |
| cachedCount                    | number                    | 4                            | 缓存的列表项数量，用于性能优化                               |
| showLoadMoreGreaterCount       | number                    | 5                            | 当item大于多少时，才显示加载更多组件，通常为一屏能显示的item数量 |
| contentStartOffset             | number                    | -                            | 设置内容区域起始偏移量                                       |
| contentEndOffset               | number                    | -                            | 设置内容区末尾偏移量                                         |
| sticky                         | StickyStyle               | StickyStyle.Header \| Footer | 吸顶样式                                                     |
| itemSpace                      | number                    | -                            | 列表项间距                                                   |
| barState                       | BarState                  | BarState.On                  | 滚动条状态                                                   |
| scrollBarColor                 | Color \| number \| string | -                            | 滚动条颜色                                                   |
| nestedScroll                   | NestedScrollOptions       | -                            | 设置前后两个方向的嵌套滚动模式，实现与父组件的滚动联动       |
| enableScrollInteraction        | boolean                   | -                            | 设置是否支持滚动手势                                         |
| pullDownRatio                  | number                    | -                            | 设置下拉跟手系数，禁止下拉设置0                              |
| refreshOffset                  | number                    | -                            | 设置触发刷新的下拉偏移量                                     |
| divider                        | RefreshListDivider        | null                         | 分割线样式                                                   |
| lanes                          | number                    | -                            | 设置List组件的布局列数或行数（网格布局）                     |
| gutter                         | Dimension                 | -                            | 列间距（网格布局时使用）                                     |
| maintainVisibleContentPosition | boolean                   | false                        | 插入或删除数据时是否保持可见内容位置不变                     |
| backToTop                      | boolean                   | true                         | 设置滚动组件是否支持点击状态栏回到顶部（API version 15+）    |
| edgeEffect                      | EdgeEffect                | -                            | List的EdgeEffect效果                                         |
| listAttrModifier               | RefreshListAttrModifier   | -                            | 用于自定义更多List属性                                       |

#### 回调函数

| 属性          | 类型                                      | 说明                                           |
| ------------- | ----------------------------------------- | ---------------------------------------------- |
| onRefresh     | () => void                                | 下拉刷新时的回调函数                           |
| onLoadMore    | () => void                                | 上拉加载更多时的回调函数                       |
| keyGenerator  | (item: ESObject, index: number) => string | 列表项唯一标识生成器                           |
| onDidScroll   | OnScrollCallback                          | 滚动时的回调函数                               |
| onReachEnd    | () => void                                | 滚动到底部时的回调函数                         |
| onScrollIndex | (start: number, end: number) => void      | 滚动到索引时的回调函数，可用于实现无感知预加载 |

#### 滚动控制器

| 属性     | 类型         | 说明                                               |
| -------- | ------------ | -------------------------------------------------- |
| scroller | ListScroller | 列表滚动控制器，可用于获取滚动位置等信息和控制滚动 |

</details>

<details>
<summary><strong>RefreshController 控制器</strong></summary>

RefreshController 提供了控制刷新列表的各种方法：

#### 属性

| 属性     | 类型         | 说明                                               |
| -------- | ------------ | -------------------------------------------------- |
| scroller | ListScroller | 列表滚动控制器，可用于获取滚动位置等信息和控制滚动 |

#### 方法

| 方法          | 参数                                                         | 返回值 | 说明                               |
| ------------- | ------------------------------------------------------------ | ------ | ---------------------------------- |
| finishRefresh | ()                                                           | void   | 结束刷新状态，必须在刷新完成后调用 |
| setHasmore    | (hasmore: boolean)                                           | void   | 设置是否还有更多数据可加载         |
| hideLoadMore  | (hide: boolean)                                              | void   | 隐藏或显示加载更多组件             |
| onRefresh     | ()                                                           | void   | 手动触发下拉刷新                   |
| scrollToIndex | (index: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) | void   | 滚动到指定索引位置                 |

#### 内部回调属性（由组件自动设置）

| 属性          | 类型                                                         | 说明                 |
| ------------- | ------------------------------------------------------------ | -------------------- |
| setHasmore    | (hasmore: boolean) => void                                   | 设置是否还有更多数据 |
| onRefresh     | () => void                                                   | 刷新回调             |
| finishRefresh | () => void                                                   | 完成刷新回调         |
| hideLoadMore  | (hide: boolean) => void                                      | 隐藏加载更多回调     |
| scrollToIndex | (value: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) => void | 滚动到指定索引回调   |

#### 使用示例

```typescript
export class SimpleViewModel {
  controller: RefreshController = new RefreshController()

  refresh(): void {
    // 模拟网络请求
    setTimeout(() => {
      // 处理数据...

      // 设置是否还有更多数据
      this.controller.setHasmore(hasMore)

      // 必须调用finishRefresh结束刷新状态
      this.controller.finishRefresh()

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

</details>

<details>
<summary><strong>RefreshDataSource 数据源</strong></summary>

RefreshDataSource 是管理列表数据的核心类，实现了 IDataSource 接口：

#### 基础方法

| 方法           | 参数            | 返回值              | 说明                                       |
| -------------- | --------------- | ------------------- | ------------------------------------------ |
| isEmpty        | ()              | boolean             | 判断数据源是否为空                         |
| totalCount     | ()              | number              | 获取数据总数 (分组时，为分组数量)          |
| totalItemCount | ()              | number              | 获取数据项总数（分组时，为分组下item总数） |
| getData        | (index: number) | Object \| undefined | 获取指定索引的数据                         |
| getLastData    | ()              | Object \| undefined | 获取最后一项数据                           |
| getDataAll     | ()              | Object[]            | 获取所有数据的副本                         |

#### 数据操作方法

| 方法             | 参数                                        | 返回值 | 说明                             |
| ---------------- | ------------------------------------------- | ------ | -------------------------------- |
| insertData       | (index: number, data: Object)               | void   | 在指定位置插入单个数据           |
| insertDataArray  | (index: number, arr: Object[])              | void   | 在指定位置插入数据数组           |
| pushData         | (data: Object)                              | void   | 在末尾添加单个数据               |
| pushDataArray    | (arr: Object[])                             | void   | 在末尾添加数据数组               |
| deleteIndex      | (index: number)                             | void   | 删除指定索引的数据               |
| deleteData       | (data: Object)                              | void   | 删除指定数据对象                 |
| deleteAll        | ()                                          | void   | 删除所有数据                     |
| deleteIndexCount | (index: number, count: number)              | void   | 从指定索引开始删除指定数量的数据 |
| replaceIndex     | (index: number, data: Object, key?: string) | void   | 替换指定索引的数据               |
| reloadIndex      | (index: number, key?: string)               | void   | 重新加载指定索引的数据           |
| reloadData       | (data: Object, key?: string)                | void   | 重新加载指定数据对象             |
| reloadDataAll    | ()                                          | void   | 重新加载所有数据                 |
| moveDataIndex    | (from: number, to: number)                  | void   | 移动数据从一个位置到另一个位置   |

#### 监听器方法

| 方法                         | 参数                           | 返回值 | 说明                   |
| ---------------------------- | ------------------------------ | ------ | ---------------------- |
| registerDataChangeListener   | (listener: DataChangeListener) | void   | 注册数据变化监听器     |
| unregisterDataChangeListener | (listener: DataChangeListener) | void   | 取消注册数据变化监听器 |

#### 回调属性

| 属性              | 类型                    | 说明                 |
| ----------------- | ----------------------- | -------------------- |
| onDataCountChange | (count: number) => void | 数据数量变化时的回调 |

</details>

<details>
<summary><strong>RefreshGroupDataSource 分组数据源</strong></summary>

RefreshGroupDataSource 继承自 RefreshDataSource，专门用于管理分组列表数据：

#### 重写方法

| 方法            | 参数 | 返回值   | 说明                       |
| --------------- | ---- | -------- | -------------------------- |
| isEmpty         | ()   | boolean  | 判断分组数据源是否为空     |
| totalItemCount  | ()   | number   | 计算所有分组中的数据项总数 |
| getGroupDataAll | ()   | Object[] | 获取所有分组中的数据项     |

#### 分组特有方法

| 方法           | 参数                                              | 返回值 | 说明                     |
| -------------- | ------------------------------------------------- | ------ | ------------------------ |
| addListToGroup | (list: Object[], getTitle: (e: Object) => string) | void   | 将数据列表按标题分组添加 |

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
    this.dataSource.replaceIndex(index, newItem)
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

</details>

<details>
<summary><strong>RefreshGroupModel 分组模型</strong></summary>

分组数据的模型类：

#### 属性

| 属性       | 类型              | 说明           |
| ---------- | ----------------- | -------------- |
| title      | string            | 分组标题       |
| dataSource | RefreshDataSource | 分组内的数据源 |
| data       | Object            | 可选的附加数据 |

#### 构造函数

```typescript
constructor(title:string, dataSource:RefreshDataSource)
```

</details>

<details>
<summary><strong>RefreshHeaderData 刷新头部数据</strong></summary>

下拉刷新头部的状态数据：

| 属性         | 类型                            | 默认值                    | 说明                                                |
| ------------ | ------------------------------- | ------------------------- | --------------------------------------------------- |
| state        | RefreshStatus                   | RefreshStatus.Inactive    | 刷新状态（Inactive、Drag、OverDrag、Refresh、Done） |
| offset       | number                          | 0                         | 下拉偏移量                                          |
| dragText     | ResourceStr                     | '下拉刷新'                | 下拉时显示的文本                                    |
| overDragText | ResourceStr                     | '释放刷新'                | 超过阈值时显示的文本                                |
| refreshText  | ResourceStr                     | '刷新中...'               | 刷新中显示的文本                                    |
| doneText     | ResourceStr                     | '刷新完成'                | 刷新完成显示的文本                                  |
| textColor    | ResourceColor                   | '#bbb'                    | 文本颜色                                            |
| font         | Font                            | { size: 13 }              | 文本字体                                            |
| loadingColor | ResourceColor \| LinearGradient | LinearGradient            | loading 颜色                                        |
| loadingSize  | SizeOptions                     | { width: 20, height: 20 } | loading 大小                                        |

#### 方法

| 方法    | 参数 | 返回值      | 说明                       |
| ------- | ---- | ----------- | -------------------------- |
| getText | ()   | ResourceStr | 根据当前状态返回对应的文本 |

</details>

<details>
<summary><strong>RefreshFooterData 刷新底部数据</strong></summary>

上拉加载更多底部的状态数据：

| 属性         | 类型               | 默认值                    | 说明                     |
| ------------ | ------------------ | ------------------------- | ------------------------ |
| isShow       | boolean            | false                     | 是否显示底部组件         |
| state        | RefreshFooterState | RefreshFooterState.None   | 加载状态                 |
| noneText     | ResourceStr        | '上拉加载更多'            | 默认状态显示的文本       |
| loadingText  | ResourceStr        | '加载中...'               | 加载中显示的文本         |
| noMoreText   | ResourceStr        | '没有更多了'              | 没有更多数据时显示的文本 |
| textColor    | ResourceColor      | '#bbb'                    | 文本颜色                 |
| font         | Font               | { size: 13 }              | 文本字体                 |
| loadingColor | ResourceColor      | '#bbb'                    | loading 颜色             |
| loadingSize  | SizeOptions        | { width: 20, height: 20 } | loading 大小             |

#### 方法

| 方法    | 参数 | 返回值      | 说明                       |
| ------- | ---- | ----------- | -------------------------- |
| getText | ()   | ResourceStr | 根据当前状态返回对应的文本 |

</details>

<details>
<summary><strong>RefreshFooterState 枚举</strong></summary>

加载更多的状态枚举：

| 值      | 数值 | 说明         |
| ------- | ---- | ------------ |
| None    | 0    | 默认状态     |
| Loading | 1    | 正在加载中   |
| NoMore  | 2    | 没有更多数据 |

</details>

<details>
<summary><strong>RefreshGlobalConfig 全局配置</strong></summary>

全局配置类，用于设置所有RefreshList组件的默认样式和行为：

#### 静态属性

| 属性               | 类型                                 | 默认值                    | 说明                                 |
| ------------------ | ------------------------------------ | ------------------------- | ------------------------------------ |
| headerBuilder      | WrappedBuilder<[IRefreshHeaderData]> | -                         | 全局自定义刷新头部构建器             |
| footerBuilder      | WrappedBuilder<[IRefreshFooterData]> | -                         | 全局自定义刷新底部构建器             |
| loadingBuilder     | WrappedBuilder<[]>                   | -                         | 全局自定义加载构建器                 |
| emptyBuilder       | WrappedBuilder<[]>                   | -                         | 全局自定义空状态构建器               |
| headerInactiveText | ResourceStr                          | '刷新'                    | 头部非活动状态文本                   |
| headerDragText     | ResourceStr                          | '下拉刷新'                | 头部下拉状态文本                     |
| headerOverDragText | ResourceStr                          | '释放刷新'                | 头部超过阈值状态文本                 |
| headerRefreshText  | ResourceStr                          | '刷新中...'               | 头部刷新中状态文本                   |
| headerDoneText     | ResourceStr                          | '刷新完成'                | 头部刷新完成状态文本                 |
| footerNoneText     | ResourceStr                          | '上拉加载更多'            | 底部默认状态文本                     |
| footerLoadingText  | ResourceStr                          | '加载中...'               | 底部加载中状态文本                   |
| footerNoMoreText   | ResourceStr                          | '没有更多了'              | 底部没有更多数据状态文本             |
| headerTextColor    | ResourceColor                        | '#bbb'                    | 头部文本颜色                         |
| footerTextColor    | ResourceColor                        | '#bbb'                    | 底部文本颜色                         |
| headerTextFont     | Font                                 | { size: 13 }              | 头部文本字体                         |
| footerTextFont     | Font                                 | { size: 13 }              | 底部文本字体                         |
| headerLoadingColor | ResourceColor \| LinearGradient      | LinearGradient            | 头部loading颜色                      |
| footerLoadingColor | ResourceColor                        | '#bbb'                    | 底部loading颜色                      |
| headerLoadingSize  | SizeOptions                          | { width: 20, height: 20 } | 头部loading大小                      |
| footerLoadingSize  | SizeOptions                          | { width: 20, height: 20 } | 底部loading大小                      |
| emptyTitleColor    | ResourceColor                        | '#999'                    | 空页面标题颜色                         |
| emptyDescColor     | ResourceColor                        | '#aaa'                    | 空页面描述文本颜色                      |
| emptyRetryButtonColor | ResourceColor                    | '#0663f6'                 | 空页面重试按钮背景颜色                   |
| emptyRetryTextColor | ResourceColor                     | '#fff'                    | 空页面重试按钮文本颜色                   |
| refreshOffset      | number                               | -                         | 设置触发刷新的下拉偏移量             |
| pullDownRatio      | number                               | -                         | 设置下拉跟手系数,有效值为0-1之间的值 |

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

</details>

<details>
<summary><strong>IRefreshHeaderData / IRefreshFooterData 接口</strong></summary>

刷新头部数据接口：

| 属性 | 类型              | 说明             |
| ---- | ----------------- | ---------------- |
| data | RefreshHeaderData | 刷新头部状态数据 |

刷新底部数据接口：

| 属性 | 类型              | 说明             |
| ---- | ----------------- | ---------------- |
| data | RefreshFooterData | 刷新底部状态数据 |

</details>

<details>
<summary><strong>RefreshListDivider 分割线接口</strong></summary>

自定义分割线样式的接口：

| 属性        | 类型          | 必需 | 说明       |
| ----------- | ------------- | ---- | ---------- |
| strokeWidth | Length        | 是   | 分割线宽度 |
| color       | ResourceColor | 否   | 分割线颜色 |
| startMargin | Length        | 否   | 起始边距   |
| endMargin   | Length        | 否   | 结束边距   |

</details>

<details>
<summary><strong>RefreshListAttrModifier 属性修饰器</strong></summary>

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

</details>

## 常见问题

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
this.controller.hideLoadMore(true) // 隐藏加载更多
this.controller.setHasmore(false) // 设置没有更多数据
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
  },
  onReachEnd: () => {
    console.log('滚动到底部')
    // 可以用于触发加载更多数据
  }
})
```

# 作者

[@仙银](https://github.com/iHongRen) 鸿蒙开源作品，欢迎持续关注

1、[hpack](https://github.com/iHongRen/hpack) - 鸿蒙 HarmonyOS 一键打包上传分发测试工具

2、[Open-in-DevEco-Studio](https://github.com/iHongRen/Open-in-DevEco-Studio)  - macOS  Finder 工具栏 app，使用 DevEco-Studio 打开鸿蒙工程

3、[cxy-theme](https://github.com/iHongRen/cxy-theme) - DevEco-Studio 绿色护眼背景主题

4、[harmony-udid-tool](https://github.com/iHongRen/harmony-udid-tool) - 简单易用的 HarmonyOS 设备 UDID 获取工具，适用于非开发人员

5、[SandboxFinder](https://github.com/iHongRen/SandboxFinder) - 鸿蒙沙箱文件浏览器，支持模拟器和真机

6、[WebServer](https://github.com/iHongRen/WebServer) - 鸿蒙轻量级Web服务器框架，类 Express.js API 风格

7、[SelectableMenu](https://github.com/iHongRen/SelectableMenu) - 适用于聊天对话框中的文本选择菜单

8、[RefreshList](https://github.com/iHongRen/RefreshList) - 功能完善的上拉下拉加载组件，支持各种自定义

9、[hm-app-check-tool](https://github.com/iHongRen/hm-app-check-tool) - macOS 鸿蒙扫描工具，扫描HAP、HSP、App包内容并输出检测结果报告

10、[hm-find-unused-res-tool](https://github.com/iHongRen/hm-find-unused-res-tool) - 鸿蒙无用资源清理工具，一个有UI的 Python 脚本

11、[harmony-study-demo](https://github.com/iHongRen/harmony-study-demo) - HarmonyOS 应用开发学习项目，包含了多个实用的功能示例



