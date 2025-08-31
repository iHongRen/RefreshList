/**
 * @fileName : SimpleListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 基础刷新和加载更多示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SimpleViewModel } from './SimpleViewModel'

@Builder
function routerBuilder() {
  SimpleListPage()
}

@Component
struct SimpleListPage {
  @State title: string = ''
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),

        // 自定义样式
        divider: { strokeWidth: 0.5, color: '#f0f0f0' },

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
