/**
 * @fileName : InfiniteListPage.ets
 * @author : @cxy
 * @date : 2025/9/5
 * @description : 无限滚动示例 - 滚动到底部自动加载更多
 */

import { RefreshList } from '@cxy/refreshlist'
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

  build() {
    NavDestination() {
      Column() {
        // 顶部统计信息（可选显示）
        this.statsHeader()

        // 无限滚动列表
        Stack() {
          RefreshList({
            dataSource: this.viewModel.dataSource,
            controller: this.viewModel.controller,
            onRefresh: () => this.viewModel.refresh(),
            onLoadMore: () => this.viewModel.loadMore(),
            itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel, index),
            divider: { strokeWidth: 0.5, color: '#f0f0f0', startMargin: 60 },
            keyGenerator: (item: ItemModel) => item.id,
            // 无限滚动的关键配置
            onReachEnd: () => {
              // 滚动到底部时自动触发加载更多（兜底机制）
              this.viewModel.loadMore()
            },
            // 提前触发加载，提升用户体验
            cachedCount: 8, // 增加缓存数量
            // 滚动监听 - 实现无感知预加载
            onScrollIndex: (firstIndex: number, lastIndex: number) => {
              // 当用户滚动时，检查是否需要预加载
              this.viewModel.checkPreload(lastIndex)
            }
          })
            .backgroundColor('#f8f9fa')

          // 预加载指示器
          if (this.viewModel.isPreloadVisible) {
            this.preloadIndicator()
          }

          // 错误提示
          if (this.viewModel.loadError) {
            this.errorIndicator()
          }
        }
        .layoutWeight(1)
      }
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  statsHeader(): void {
    Row() {
      Column() {
        Text('已加载')
          .fontSize(12)
          .fontColor('#666')
        Text(this.viewModel.loadedCount.toString())
          .fontSize(18)
          .fontColor('#333')
          .fontWeight(FontWeight.Bold)
      }
      .layoutWeight(1)

      Column() {
        Text('当前页')
          .fontSize(12)
          .fontColor('#666')
        Text(`${this.viewModel.currentPage}/${this.viewModel.totalPages}`)
          .fontSize(18)
          .fontColor('#333')
          .fontWeight(FontWeight.Bold)
      }
      .layoutWeight(1)

      Column() {
        Text('状态')
          .fontSize(12)
          .fontColor('#666')
        Text(this.viewModel.getLoadingStatus())
          .fontSize(14)
          .fontColor(this.viewModel.getStatusColor())
          .fontWeight(FontWeight.Medium)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fff')
    .margin({ bottom: 8 })
  }

  @Builder
  itemLayout(item: ItemModel, index: number): void {
    ListItem() {
      Row() {
        // 左侧头像和序号
        Stack() {
          Column() {
            Text(item.initial || item.title.charAt(0))
              .fontSize(14)
              .fontColor('#fff')
              .fontWeight(FontWeight.Medium)
          }
          .width(44)
          .height(44)
          .borderRadius(22)
          .backgroundColor(item.avatarColor || '#4CAF50')
          .justifyContent(FlexAlign.Center)

          // 序号标识
          if (item.index) {
            Text(item.index.toString())
              .fontSize(10)
              .fontColor('#fff')
              .backgroundColor('#f00')
              .borderRadius(8)
              .padding({
                left: 4,
                right: 4,
                top: 1,
                bottom: 1
              })
              .position({ x: 30, y: -5 })
          }
        }
        .alignContent(Alignment.TopEnd)

        // 内容区域
        Column() {
          // 标题行
          Row() {
            Text(item.title)
              .fontSize(16)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            if (item.isHot) {
              Text('HOT')
                .fontSize(10)
                .fontColor('#fff')
                .backgroundColor('#ff4444')
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
                .borderRadius(8)
                .margin({ left: 8 })
            }
          }
          .width('100%')

          // 描述
          if (item.description) {
            Text(item.description)
              .fontSize(14)
              .fontColor('#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 分类和作者
          Row() {
            Text(`#${item.category}`)
              .fontSize(12)
              .fontColor('#2196F3')
              .backgroundColor('#E3F2FD')
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
              .borderRadius(4)

            Text(`@${item.author}`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ left: 8 })
          }
          .margin({ top: 6 })

          // 底部统计信息
          Row() {
            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')

            Blank()

            // 统计数据
            Row({ space: 12 }) {
              Row({ space: 4 }) {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor('#999')
                Text(this.viewModel.formatNumber(item.views || 0))
                  .fontSize(12)
                  .fontColor('#999')
              }

              Row({ space: 4 }) {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor('#999')
                Text(this.viewModel.formatNumber(item.likes || 0))
                  .fontSize(12)
                  .fontColor('#999')
              }

              Row({ space: 4 }) {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor('#999')
                Text(this.viewModel.formatNumber(item.comments || 0))
                  .fontSize(12)
                  .fontColor('#999')
              }
            }
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
    }
    .onClick(() => {
      console.log(`点击文章: ${item.title}`)
      // 这里可以跳转到详情页
    })
  }

  @Builder
  preloadIndicator(): void {
    Row() {
      LoadingProgress()
        .width(16)
        .height(16)
        .color('#666')

      Text('智能加载中...')
        .fontSize(12)
        .fontColor('#666')
        .margin({ left: 8 })
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8
    })
    .backgroundColor('#f0f0f0')
    .borderRadius(16)
    .position({ x: '50%', y: '90%' })
    .translate({ x: '-50%', y: '-50%' })
    .zIndex(10)
  }

  @Builder
  errorIndicator(): void {
    Column() {
      Text('加载失败')
        .fontSize(14)
        .fontColor('#ff4444')
        .fontWeight(FontWeight.Medium)

      Text(this.viewModel.loadError)
        .fontSize(12)
        .fontColor('#666')
        .margin({ top: 4 })

      Button('重试')
        .fontSize(12)
        .backgroundColor('#ff4444')
        .fontColor('#fff')
        .padding({
          left: 16,
          right: 16,
          top: 4,
          bottom: 4
        })
        .margin({ top: 8 })
        .onClick(() => {
          this.viewModel.retryLoad()
        })
    }
    .padding(16)
    .backgroundColor('#fff')
    .borderRadius(8)
    .shadow({
      radius: 8,
      color: '#00000020',
      offsetX: 0,
      offsetY: 2
    })
    .position({ x: '50%', y: '50%' })
    .translate({ x: '-50%', y: '-50%' })
    .zIndex(20)
  }
}