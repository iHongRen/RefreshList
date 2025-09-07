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
  @State showStats: boolean = false

  build() {
    NavDestination() {
      Column() {
        // 顶部统计信息（可选显示）
        if (this.showStats) {
          this.statsHeader()
        }

        // 无限滚动列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
          divider: { strokeWidth: 0.5, color: '#f0f0f0', startMargin: 60 },
          keyGenerator: (item: ItemModel) => item.id,
          // 无限滚动的关键配置
          onReachEnd: () => {
            // 滚动到底部时自动触发加载更多
            this.viewModel.loadMore()
          },
          // 提前触发加载，提升用户体验
          cachedCount: 6
        })
          .layoutWeight(1)
          .backgroundColor('#f8f9fa')
      }
    }
    .title(this.title)
    .menus([
      {
        value: this.showStats ? '隐藏统计' : '显示统计',
        action: () => {
          this.showStats = !this.showStats
        }
      }
    ])
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
        Text(this.viewModel.getDataStats().total.toString())
          .fontSize(18)
          .fontColor('#333')
          .fontWeight(FontWeight.Bold)
      }
      .layoutWeight(1)

      Column() {
        Text('当前页')
          .fontSize(12)
          .fontColor('#666')
        Text(`${this.viewModel.getDataStats().currentPage}/${this.viewModel.getDataStats().totalPages}`)
          .fontSize(18)
          .fontColor('#333')
          .fontWeight(FontWeight.Bold)
      }
      .layoutWeight(1)

      Column() {
        Text('状态')
          .fontSize(12)
          .fontColor('#666')
        Text(this.viewModel.getLoadingState() ? '加载中' : '就绪')
          .fontSize(14)
          .fontColor(this.viewModel.getLoadingState() ? '#ff9800' : '#4caf50')
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
  itemLayout(item: ItemModel): void {
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
              .backgroundColor('#333')
              .borderRadius(8)
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
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
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
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
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
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
                Text(this.formatNumber(item.views || 0))
                  .fontSize(12)
                  .fontColor('#999')
              }

              Row({ space: 4 }) {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor('#999')
                Text(this.formatNumber(item.likes || 0))
                  .fontSize(12)
                  .fontColor('#999')
              }

              Row({ space: 4 }) {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor('#999')
                Text(this.formatNumber(item.comments || 0))
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

  // 格式化数字显示
  private formatNumber(num: number): string {
    if (num >= 10000) {
      return `${Math.floor(num / 1000)}k`
    } else if (num >= 1000) {
      return `${(num / 1000).toFixed(1)}k`
    }
    return num.toString()
  }
}