/**
 * @fileName : InfiniteListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 无限滚动示例
 */

import { RefreshList, RefreshFooterData, RefreshFooterState } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { InfiniteViewModel } from './InfiniteViewModel'

@Builder
function routerBuilder() {
  InfiniteListPage()
}

@Component
struct InfiniteListPage {
  @State title: string = ''
  @State viewModel: InfiniteViewModel = new InfiniteViewModel()
  @State isAutoLoading: boolean = false

  build() {
    NavDestination() {
      Column() {
        // 控制面板
        this.controlPanel()

        // 无限滚动列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.infiniteItemLayout(item as ItemModel),

          // 自定义加载更多样式
          refreshFooterLayout: () => this.customFooterLayout(),

          // 滚动回调
          onDidScroll: (scrollOffset: number, scrollState: ScrollState) => {
            this.handleScroll(scrollOffset, scrollState)
          },

          onReachEnd: () => {
            console.log('到达底部')
          },

          keyGenerator: (item: ItemModel) => item.id
        })
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  controlPanel(): void {
    Column() {
      Row() {
        Text('无限滚动演示')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button(this.isAutoLoading ? '停止自动加载' : '开启自动加载')
          .fontSize(12)
          .backgroundColor(this.isAutoLoading ? '#ff4444' : '#007AFF')
          .onClick(() => {
            this.isAutoLoading = !this.isAutoLoading
            this.viewModel.setAutoLoading(this.isAutoLoading)
          })
      }
      .width('100%')
      .padding(15)

      Row() {
        Text(`已加载: ${this.viewModel.dataSource.totalCount()} 项`)
          .fontSize(14)
          .fontColor('#666')

        Blank()

        Text(`页数: ${this.viewModel.getCurrentPage()}`)
          .fontSize(14)
          .fontColor('#666')

        Blank()

        Text(`状态: ${this.viewModel.getLoadingStatus()}`)
          .fontSize(14)
          .fontColor(this.viewModel.getLoadingStatus() === '加载中' ? '#ff6b6b' : '#666')
      }
      .width('100%')
      .padding({ left: 15, right: 15, bottom: 15 })
    }
    .backgroundColor('#f8f8f8')
  }

  @Builder
  infiniteItemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 序号
        Text(`${item.index || 0}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007AFF')
          .width(50)
          .textAlign(TextAlign.Center)

        // 内容
        Column() {
          Text(item.title)
            .fontSize(16)
            .fontColor('#333')
            .fontWeight(FontWeight.Medium)

          Text(item.description || '这是一个无限滚动的列表项')
            .fontSize(14)
            .fontColor('#666')
            .margin({ top: 4 })

          Row() {
            Text(`ID: ${item.id}`)
              .fontSize(12)
              .fontColor('#999')

            Blank()

            Text(String(item.timestamp))
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 操作按钮
        Column() {
          Button('详情')
            .fontSize(12)
            .backgroundColor('#f0f0f0')
            .fontColor('#333')
            .onClick(() => {
              console.log(`查看详情: ${item.title}`)
            })
        }
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor(Color.White)
    .margin({ bottom: 1 })
  }

  @Builder
  customFooterLayout(): void {
    Column() {
      if (this.viewModel.hasMore()) {
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
            .color('#ff6b6b')

          Text(this.isAutoLoading ? '自动加载中...' : '加载更多数据...')
            .fontSize(14)
            .fontColor('#666')
            .margin({ left: 8 })
        }
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          Text('🎉 已加载全部数据')
            .fontSize(14)
            .fontColor('#999')

          Text(`共 ${this.viewModel.dataSource.totalCount()} 条记录`)
            .fontSize(12)
            .fontColor('#ccc')
            .margin({ top: 4 })
        }
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#f8f8f8')
  }

  private handleScroll(scrollOffset: number, scrollState: ScrollState): void {
    // 处理滚动事件，可以用于实现更复杂的无限滚动逻辑
    if (this.isAutoLoading && scrollState === ScrollState.Scroll) {
      // 自动加载模式下的处理逻辑
    }
  }
}