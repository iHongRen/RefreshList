/**
 * @fileName : GlobalPage.ets
 * @author : @cxy
 * @date : 2025/9/4
 * @description : 文件描述
 */

import {
  IRefreshHeaderData,
  RefreshFooterData,
  RefreshGlobalConfig,
  RefreshHeaderData,
  RefreshList
} from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SimpleViewModel } from '../simple/SimpleViewModel'

@Builder
function headerBuilder(item: IRefreshHeaderData) {
  GlobalHeader({ data: item.data })
}

@Component
struct GlobalHeader {
  @ObjectLink data: RefreshHeaderData

  refresText(): string {
    console.error('==================' + this.data.state)
    if (this.data.state === RefreshStatus.Drag) {
      return '下拉刷新'
    }
    if (this.data.state === RefreshStatus.OverDrag) {
      return '释放刷新'
    }
    if (this.data.state === RefreshStatus.Done) {
      return '刷新完成'
    }
    if (this.data.state === RefreshStatus.Refresh) {
      return '正在刷新'
    }
    return '下拉刷新'
  }

  build() {
    Column({ space: 5 }) {
      Image($r('app.media.custom_loading'))
        .height(25)

      Text(this.refresText())
        .fontColor('#999')
        .fontSize(13)
    }
    .padding(10)

  }
}

@Component
struct GlobalFooter {
  @ObjectLink data: RefreshFooterData

  build() {
    Image($r('app.media.custom_loading'))
      .height(30)
      .margin(10)
  }
}

function globalConfig() {
  RefreshGlobalConfig.headerBuilder = wrapBuilder(headerBuilder)
  RefreshGlobalConfig.footerNoneText = '上拉加载' //默认文本
  RefreshGlobalConfig.footerLoadingText = '数据加载中...' //加载中文本
  RefreshGlobalConfig.footerNoMoreText = '亲，没有更多了' //没有更多文本
}

globalConfig()

@Builder
function routerBuilder() {
  GlobalPage()
}

@Component
struct GlobalPage {
  @State title: string = ''
  @State viewModel: SimpleViewModel = new SimpleViewModel()

  aboutToAppear(): void {
    globalConfig()
  }

  build() {
    NavDestination() {
      RefreshList({
        dataSource: this.viewModel.dataSource,
        controller: this.viewModel.controller,
        onRefresh: () => this.viewModel.refresh(),
        onLoadMore: () => this.viewModel.loadMore(),
        itemLayout: (item: Object, index: number) => this.itemLayout(item as ItemModel),
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