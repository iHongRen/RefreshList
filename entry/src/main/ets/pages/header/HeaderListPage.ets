/**
 * @fileName : HeaderListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 带头部视图的列表示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { RefreshLoadingView } from '@cxy/refreshlist/src/main/ets/refreshlist/RefreshLoadingView'
import { ItemModel } from '../../models/ItemModel'
import { HeaderViewModel } from './HeaderViewModel'

@Builder
function routerBuilder() {
  HeaderListPage()
}

interface StatItem {
  title: string,
  count: string
}

@Component
struct HeaderListPage {
  @State title: string = ''
  @State viewModel: HeaderViewModel = new HeaderViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        // 自定义头部布局
        headerLayout: () => this.headerLayout(),
        loadingLayout: () => this.loadingLayout(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
        keyGenerator: (item: ItemModel) => item.id
      })
        .backgroundColor('#f8f9fa')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  loadingLayout(): void {
    RefreshLoadingView().height(200)
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
          // 标题区域
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
      .padding({
        left: 16,
        right: 16,
        top: 16,
        bottom: 16
      })
      .justifyContent(FlexAlign.SpaceBetween)

      // 分隔线
      Divider()
        .color('#eee')
        .strokeWidth(1)
        .margin({ left: 16, right: 16 })
    }
    .backgroundColor('#fff')
  }

  @Builder
  statItem(item: StatItem): void {
    Column() {
      Text(item.title)
        .fontSize(18)
        .fontColor('#fff')
        .fontWeight(FontWeight.Bold)

      Text(item.count)
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

  @Builder
  itemLayout(item: ItemModel): void {
    ListItem() {
      Column() {
        Row() {
          // 左侧图标
          Column() {
            Text(item.initial || '📄')
              .fontSize(16)
              .fontColor('#fff')
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

              if (item.category) {
                Text(item.category)
                  .fontSize(10)
                  .fontColor('#2196F3')
                  .backgroundColor('#e3f2fd')
                  .padding({
                    left: 6,
                    right: 6,
                    top: 2,
                    bottom: 2
                  })
                  .borderRadius(4)
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

        Divider().strokeWidth(0.5).color('#eee')
      }
    }
    .onClick(() => {
      console.log(`点击项目: ${item.title}`)
    })
  }
}