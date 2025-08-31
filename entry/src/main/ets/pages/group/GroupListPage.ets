/**
 * @fileName : GroupListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 分组刷新和加载更多示例
 */

import { RefreshGroupModel, RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { GroupViewModel } from './GroupViewModel'

@Builder
function routerBuilder() {
  GroupListPage()
}

@Component
struct GroupListPage {
  @State title: string = ''
  @State viewModel: GroupViewModel = new GroupViewModel()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (group: Object, index: number) => this.groupLayout(group as RefreshGroupModel),

        // 自定义样式
        divider: { strokeWidth: 0, color: 'transparent' },

        keyGenerator: (group: RefreshGroupModel) => group.title
      })
        .backgroundColor('#f5f5f5')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
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
      .width(32)
      .height(32)
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

      // 展开/收起图标
      Image($r('sys.media.ohos_ic_public_arrow_down'))
        .width(16)
        .height(16)
        .fillColor('#999')
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor('#fff')
    .borderRadius({ topLeft: 12, topRight: 12 })
    .shadow({
      radius: 4,
      color: '#1a000000',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  groupItemLayout(item: ItemModel, index: number): void {
    Row() {
      // 序号
      Text(`${index + 1}`)
        .fontSize(12)
        .fontColor('#999')
        .width(24)
        .textAlign(TextAlign.Center)

      // 内容区域
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

        // 标签和时间
        Row() {
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
          }

          Blank()

          Text(item.time || '刚刚')
            .fontSize(12)
            .fontColor('#999')
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      // 状态指示器
      if (item.isNew) {
        Column() {
          Text('新')
            .fontSize(10)
            .fontColor('#fff')
            .backgroundColor('#ff4444')
            .padding({
              left: 4,
              right: 4,
              top: 1,
              bottom: 1
            })
            .borderRadius(6)
        }
      }
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor('#fff')
    .onClick(() => {
      console.log(`点击分组项目: ${item.title}`)
    })
  }
}