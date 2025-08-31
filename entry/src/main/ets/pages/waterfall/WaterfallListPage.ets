/**
 * @fileName : WaterfallListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 瀑布流布局示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { WaterfallViewModel } from './WaterfallViewModel'

@Builder
function routerBuilder() {
  WaterfallListPage()
}

@Component
struct WaterfallListPage {
  @State title: string = ''
  @State viewModel: WaterfallViewModel = new WaterfallViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),

        // 使用自定义布局实现瀑布流
        customLayout: () => this.waterfallLayout(),

        // 自定义刷新样式
        refreshHeaderLayout: () => this.customRefreshHeader(),
        refreshFooterLayout: () => this.customRefreshFooter(),

        keyGenerator: (item: ItemModel) => item.id
      })
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  waterfallLayout(): void {
    // 使用WaterFlow组件实现瀑布流
    WaterFlow() {
      LazyForEach(this.viewModel.dataSource, (item: ItemModel, index: number) => {
        FlowItem() {
          this.waterfallItemLayout(item)
        }
      }, (item: ItemModel) => item.id)
    }
    .columnsTemplate('1fr 1fr') // 两列瀑布流
    .columnsGap(10)
    .rowsGap(10)
    .padding(10)
    .width('100%')
    .height('100%')
  }

  @Builder
  waterfallItemLayout(item: ItemModel): void {
    Column() {
      // 图片区域 - 随机高度
      Image(item.image || $r('app.media.app_icon'))
        .width('100%')
        .height(item.imageHeight || 150)
        .borderRadius({ topLeft: 12, topRight: 12 })
        .objectFit(ImageFit.Cover)

      // 内容区域
      Column() {
        Text(item.title)
          .fontSize(14)
          .fontColor('#333')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(20)

        if (item.description) {
          Text(item.description)
            .fontSize(12)
            .fontColor('#666')
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 6 })
        }

        // 底部信息
        Row() {
          Row() {
            Image($r('sys.media.ohos_app_icon'))
              .width(14)
              .height(14)
              .fillColor('#ff4444')
            Text(`${item.likes || 0}`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ left: 4 })
          }

          Row() {
            Image($r('sys.media.ohos_app_icon'))
              .width(14)
              .height(14)
              .fillColor('#666')
            Text(`${item.comments || 0}`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ left: 4 })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 10 })

        // 用户信息
        Row() {
          Image(item.avatar || $r('app.media.app_icon'))
            .width(20)
            .height(20)
            .borderRadius(10)

          Text(item.author || '匿名用户')
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 6 })
        }
        .margin({ top: 8 })
      }
      .padding(12)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: '#1a000000',
      offsetX: 0,
      offsetY: 4
    })
    .onClick(() => {
      console.log(`点击瀑布流项目: ${item.title}`)
    })
  }

  @Builder
  customRefreshHeader(): void {
    Column() {
      Row() {
        LoadingProgress()
          .width(24)
          .height(24)
          .color('#ff6b6b')

        Text('发现更多精彩内容...')
          .fontSize(14)
          .fontColor('#666')
          .margin({ left: 8 })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  customRefreshFooter(): void {
    Column() {
      Row() {
        LoadingProgress()
          .width(20)
          .height(20)
          .color('#ff6b6b')

        Text('加载更多创意...')
          .fontSize(12)
          .fontColor('#999')
          .margin({ left: 6 })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
}