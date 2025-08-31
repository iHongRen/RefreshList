/**
 * @fileName : PerformanceListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 性能优化示例 - 大数据量列表
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { PerformanceViewModel } from './PerformanceViewModel'

@Builder
function routerBuilder() {
  PerformanceListPage()
}

@Component
struct PerformanceListPage {
  @State title: string = ''
  @State viewModel: PerformanceViewModel = new PerformanceViewModel()
  @State showPerformanceInfo: boolean = true

  build() {
    NavDestination() {
      Column() {
        // 性能信息面板
        if (this.showPerformanceInfo) {
          this.performancePanel()
        }

        // 高性能列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.performanceItemLayout(item as ItemModel),

          // 性能优化配置
          cachedCount: 20, // 增加缓存数量
          itemSpace: 1, // 最小间距

          // 滚动性能监控
          onDidScroll: (scrollOffset: number, scrollState: ScrollState) => {
            this.viewModel.updateScrollInfo(scrollOffset, scrollState)
          },

          onScrollIndex: (start: number, end: number) => {
            this.viewModel.updateVisibleRange(start, end)
          },

          keyGenerator: (item: ItemModel) => item.id
        })
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .menus(this.menusBuilder)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  menusBuilder() {
    Row() {
      Text(this.showPerformanceInfo ? '隐藏' : '显示')
        .fontSize(14)
        .fontColor('#007AFF')
        .onClick(() => {
          this.showPerformanceInfo = !this.showPerformanceInfo
        })
    }
  }

  @Builder
  performancePanel(): void {
    Column() {
      Row() {
        Text('性能监控')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Blank()

        Text(`FPS: ${this.viewModel.getFPS()}`)
          .fontSize(12)
          .fontColor('#00C851')
      }
      .width('100%')
      .padding({ bottom: 10 })

      Row() {
        Column() {
          Text('数据量')
            .fontSize(12)
            .fontColor('#666')
          Text(`${this.viewModel.dataSource.totalCount()}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
        }
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text('可见范围')
            .fontSize(12)
            .fontColor('#666')
          Text(this.viewModel.getVisibleRange())
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
        }
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text('内存使用')
            .fontSize(12)
            .fontColor('#666')
          Text(this.viewModel.getMemoryUsage())
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ff6b6b')
        }
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text('滚动状态')
            .fontSize(12)
            .fontColor('#666')
          Text(this.viewModel.getScrollState())
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .padding(15)
    .backgroundColor('#f8f8f8')
    .border({ width: { bottom: 1 }, color: '#e0e0e0' })
  }

  @Builder
  overlyBuilder(text: string) {
    Text(text)
      .fontSize(16)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
  }

  @Builder
  performanceItemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 简化的头像 - 使用纯色圆形减少渲染开销
        Circle({ width: 40, height: 40 })
          .fill(item.avatarColor || '#007AFF')
          .overlay(this.overlyBuilder(item.initial || 'A'))

        // 内容区域 - 优化文本渲染
        Column() {
          Text(item.title)
            .fontSize(16)
            .fontColor('#333')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(item.subtitle || '性能优化示例项目')
            .fontSize(14)
            .fontColor('#666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })

          Row() {
            Text(`#${item.index}`)
              .fontSize(12)
              .fontColor('#999')

            Text('•')
              .fontSize(12)
              .fontColor('#ddd')
              .margin({ left: 8, right: 8 })

            Text(item.category || '默认分类')
              .fontSize(12)
              .fontColor('#999')
          }
          .margin({ top: 6 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 状态指示器
        Column() {
          if (item.isHot) {
            Text('HOT')
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('#ff4444')
              .borderRadius(8)
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
          }

          Text(item.score?.toString() || '0')
            .fontSize(12)
            .fontColor('#666')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .padding({
        left: 15,
        right: 15,
        top: 10,
        bottom: 10
      })
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor(Color.White)
    .onClick(() => {
      // 优化点击处理 - 避免复杂操作
      console.log(`快速点击: ${item.title}`)
    })
  }
}