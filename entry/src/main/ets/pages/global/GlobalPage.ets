/**
 * @fileName : GlobalPage.ets
 * @author : @cxy
 * @date : 2025/9/4
 * @description : 全局配置
 */

import {
  IRefreshFooterData,
  IRefreshHeaderData,
  RefreshFooterData,
  RefreshGlobalConfig,
  RefreshHeaderData,
  RefreshList
} from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { SimpleViewModel } from '../simple/SimpleViewModel'

import { LottieController, Lottie } from '@jjr/lottie_component';

@Component
struct LottieHeader {
  @ObjectLink data: RefreshHeaderData
  private controller: LottieController = new LottieController();

  build() {
    Column({ space: 5 }) {
      Lottie({
        controller: this.controller,
        animationPath: 'refresh_header.json', // rawfile目录
        autoPlay: true,
      }).height(30)
      Text(this.data.getText())
        .font(this.data.font)
    }
    .padding(10)
  }
}

@Builder
function headerBuilder(item: IRefreshHeaderData) {
  LottieHeader({ data: item.data })
  // GlobalHeader({ data: item.data })
}

@Component
struct GlobalHeader {
  @ObjectLink data: RefreshHeaderData

  build() {
    Column({ space: 5 }) {
      Image($r('app.media.custom_loading'))
        .height(25)

      Text(this.data.getText())
        .fontColor(this.data.textColor)
        .font(this.data.font)
    }
    .padding(10)
  }
}

@Builder
function footerBuilder(item: IRefreshFooterData) {
  GlobalFooter({ data: item.data })
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

// 配置全局设置
function setupGlobalConfig() {
  RefreshGlobalConfig.headerBuilder = wrapBuilder(headerBuilder)
  RefreshGlobalConfig.headerDragText = '下拉刷新数据'
  RefreshGlobalConfig.headerOverDragText = '释放立即刷新'
  RefreshGlobalConfig.headerRefreshText = '正在刷新数据...'
  RefreshGlobalConfig.headerDoneText = '刷新成功'

  RefreshGlobalConfig.footerBuilder = wrapBuilder(footerBuilder)
  RefreshGlobalConfig.footerNoneText = '上拉加载更多'
  RefreshGlobalConfig.footerLoadingText = '数据加载中...'
  RefreshGlobalConfig.footerNoMoreText = '亲，没有更多了'
  RefreshGlobalConfig.headerTextColor = '#f00'
  RefreshGlobalConfig.footerTextColor = '#666'
}

setupGlobalConfig()

@Builder
function routerBuilder() {
  GlobalPage()
}

@Component
struct GlobalPage {
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