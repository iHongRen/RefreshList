/**
 * @fileName : GridListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 多列网格布局示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { GridViewModel } from './GridViewModel'

@Builder
function routerBuilder() {
  GridListPage()
}

@Component
struct GridListPage {
  @State title: string = ''
  @State viewModel: GridViewModel = new GridViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.gridItemLayout(item as ItemModel),

        // 网格布局配置
        lanes: 2, // 两列布局
        gutter: 10, // 列间距
        itemSpace: 10, // 行间距

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
            .lineHeight(20)

          Text(`¥${item.price || '99.00'}`)
            .fontSize(16)
            .fontColor('#ff4444')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 8 })

          Row() {
            Text(`销量${item.sales || '999+'}`)
              .fontSize(12)
              .fontColor('#999')

            Row() {
              ForEach([1, 2, 3, 4, 5], (star: number) => {
                Image($r('sys.media.ohos_app_icon'))
                  .width(12)
                  .height(12)
                  .fillColor(star <= (item.rating || 4) ? '#ffcc00' : '#ddd')
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
    .onClick(() => {
      console.log(`点击商品: ${item.title}`)
    })
  }
}