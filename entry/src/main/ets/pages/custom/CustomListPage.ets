/**
 * @fileName : CustomListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 自定义使用示例 - 展示完全自定义的列表实现
 */

import {
  RefreshFooterData, RefreshFooterState, RefreshHeaderData, RefreshList
} from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { CustomListModel } from './CustomListModel'

@Builder
function routerBuilder() {
  CustomListPage()
}

@Component
struct CustomListPage {
  @State title: string = ''
  @State viewModel: CustomListModel = new CustomListModel()
  @State refreshHeaderData: RefreshHeaderData = new RefreshHeaderData()
  @State refreshFooterData: RefreshFooterData = new RefreshFooterData()

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),

        // 自定义的刷新和加载组件
        refreshHeaderLayout: () => this.refreshHeaderLayout(),
        refreshFooterLayout: () => this.refreshFooterLayout(),

        // 自定义列表内容布局
        customLayout: () => this.customLayout(),

        // 自定义加载中布局
        loadingLayout: () => this.loadingBuilder(),

        // 自定义空页面布局
        emptyLayout: () => this.emptyBuilder(),

        // 自定义的刷新和加载数据
        refreshHeaderData: this.refreshHeaderData,
        refreshFooterData: this.refreshFooterData,

        // 样式配置
        divider: { strokeWidth: 0, color: 'transparent' },
      })
        .backgroundColor('#f0f2f5')
    }
    .menus(this.menusBuilder)
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  menusBuilder(): void {
    Row() {
      Text('清空')
        .fontColor('#ff4444')
        .fontSize(16)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.viewModel.dataSource.deleteAll()
        })
    }
    .height('100%')
  }

  // 自定义刷新头部动画
  @Builder
  refreshHeaderLayout(): void {
    Column() {
      Image($r('app.media.custom_header'))
        .width(34)
    }
    .padding(10)
  }

  // 自定义刷新底部动画
  @Builder
  refreshFooterLayout(): void {
    Column() {
      // 根据不同状态显示不同内容
      if (this.refreshFooterData.state === RefreshFooterState.Loading) {
        // 加载中状态
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
            .color('#667eea')

          Text('加载更多内容...')
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 6 })
        }
        .justifyContent(FlexAlign.Center)

      } else if (this.refreshFooterData.state === RefreshFooterState.NoMore) {
        // 没有更多数据状态
        Row() {
          Divider()
            .width(60)
            .height(1)
            .color('#ddd')

          Text('没有更多数据了')
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 12, right: 12 })

          Divider()
            .width(60)
            .height(1)
            .color('#ddd')
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
      } else {
        // 默认状态或其他状态
        Row() {
          Text('上拉加载更多')
            .fontSize(12)
            .fontColor('#999')
        }
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#fff')
    .visibility(this.refreshFooterData.isShow ? Visibility.Visible : Visibility.None)
  }

  // 自定义列表内容布局
  @Builder
  customLayout(): void {
    LazyForEach(this.viewModel.dataSource, (item: ItemModel, index: number) => {
      ListItem() {
        this.customItemLayout(item, index)
      }
    }, (item: ItemModel) => item.id)
  }

  // 自定义加载状态布局
  @Builder
  loadingBuilder(): void {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#667eea')

      Text('正在加载数据...')
        .fontSize(14)
        .fontColor('#666')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 自定义空状态布局
  @Builder
  emptyBuilder(): void {
    Column() {
      // 空状态图标
      Text('📭')
        .fontSize(48)
        .margin({ bottom: 16 })

      Text('暂无数据')
        .fontSize(18)
        .fontColor('#333')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 8 })

      Text('点击下方按钮刷新数据')
        .fontSize(14)
        .fontColor('#999')
        .margin({ bottom: 24 })

      // 刷新按钮
      Button('刷新数据')
        .fontSize(14)
        .backgroundColor('#667eea')
        .borderRadius(20)
        .padding({
          left: 24,
          right: 24,
          top: 8,
          bottom: 8
        })
        .onClick(() => {
          this.viewModel.refresh()
        })
    }
    .width('100%')
    .height(300)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  customItemLayout(item: ItemModel, index: number): void {
    Column() {
      Row() {
        // 序号标识
        Column() {
          Text(`${index + 1}`)
            .fontSize(14)
            .fontColor('#fff')
            .fontWeight(FontWeight.Bold)
        }
        .width(32)
        .height(32)
        .borderRadius(16)
        .backgroundColor(item.avatarColor || '#667eea')
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

          // 标签和时间
          Row() {
            if (item.category) {
              Text(item.category)
                .fontSize(10)
                .fontColor('#667eea')
                .backgroundColor('#f0f2ff')
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

        // 操作按钮
        Column() {
          Image($r('sys.media.ohos_ic_public_more'))
            .width(20)
            .height(20)
            .fillColor('#ccc')
        }
        .onClick(() => {
          console.log(`操作项目: ${item.title}`)
        })
      }
      .width('100%')
      .padding(16)

      // 自定义分隔线
      if (index < this.viewModel.dataSource.totalCount() - 1) {
        Divider()
          .strokeWidth(1)
          .color('#f0f0f0')
          .margin({ left: 60, right: 16 })
      }
    }
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(index === 0 ? { topLeft: 12, topRight: 12 } : 0)
    .onClick(() => {
      console.log(`点击自定义项目: ${item.title}`)
    })
  }
}